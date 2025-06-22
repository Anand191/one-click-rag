import time
from abc import ABC

import torch
from docling_core.types.doc import DoclingDocument
from docling_core.types.doc.document import DocTagsDocument
from loguru import logger
from PIL.Image import Image
from transformers import AutoModelForVision2Seq, AutoProcessor

DEVICE = "cuda" if torch.cuda.is_available() else "cpu"
logger.info(f"Using device: {DEVICE}")


class PdfParser(ABC):
    def __init__(self, modelPath: str):
        super().__init__()
        # Initialize processor and model
        self.processor = AutoProcessor.from_pretrained(modelPath)
        self.model = AutoModelForVision2Seq.from_pretrained(
            modelPath,
            device_map="auto",
            torch_dtype=torch.bfloat16,
            _attn_implementation="eager",  # for gpu that does not supports flash attention
        ).to(DEVICE)

    def prep_input(self, prompt_template: str, image: Image) -> list:
        # Create input messages
        messages = [
            {"role": "user", "content": [{"type": "image"}, {"type": "text", "text": prompt_template}]},
        ]
        # Prepare inputs
        prompt = self.processor.apply_chat_template(messages, add_generation_prompt=True)
        inputs = self.processor(text=prompt, images=[image], return_tensors="pt")
        return inputs.to(DEVICE)

    def generate_output(self, inputs) -> list:
        # Generate outputs
        generated_ids = self.model.generate(**inputs, max_new_tokens=8192)
        prompt_length = inputs.input_ids.shape[1]
        trimmed_generated_ids = generated_ids[:, prompt_length:]
        doctags = self.processor.batch_decode(
            trimmed_generated_ids,
            skip_special_tokens=False,
        )[0].lstrip()
        return doctags

    def export_document(self, prompt: str, image: Image):
        start_time = time.time()
        inputs = self.prep_input(prompt, image)
        doctags = self.generate_output(inputs)
        # Populate document
        doctags_doc = DocTagsDocument.from_doctags_and_image_pairs([doctags], [image])
        # logger.debug(doctags)
        # create a docling document
        doc = DoclingDocument(name="Document")
        doc.load_from_doctags(doctags_doc)
        end_time = time.time()
        return doc, end_time - start_time
