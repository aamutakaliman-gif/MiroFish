from app.config import Config
from app.utils.llm_client import LLMClient


def test_llm_client_uses_configured_max_retries(monkeypatch):
    monkeypatch.setattr(Config, "LLM_MAX_RETRIES", 7)
    client = LLMClient(api_key="test-key", base_url="http://localhost:1/v1", model="m")
    assert client.client.max_retries == 7

