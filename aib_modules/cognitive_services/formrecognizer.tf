# Create Cognitive Services Account
# ["Academic" "AnomalyDetector" "Bing.Autosuggest" "Bing.Autosuggest.v7" "Bing.CustomSearch" "Bing.Search" "Bing.Search.v7" "Bing.Speech" "Bing.SpellCheck" "Bing.SpellCheck.v7" "CognitiveServices" "ComputerVision" "ContentModerator" "ConversationalLanguageUnderstanding" "ContentSafety" "CustomSpeech" "CustomVision.Prediction" "CustomVision.Training" "Emotion" "Face" "FormRecognizer" "ImmersiveReader" "LUIS" "LUIS.Authoring" "MetricsAdvisor" "OpenAI" "Personalizer" "QnAMaker" "Recommendations" "SpeakerRecognition" "Speech" "SpeechServices" "SpeechTranslation" "TextAnalytics" "TextTranslation" "WebLM"]
resource "azurerm_cognitive_account" "formrecognizer" {
  name                          = "di-fr-${var.name}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku_name                      = var.sku_name
  kind                          = "FormRecognizer"
  tags                          = var.tags
  custom_subdomain_name         = "di-fr-${var.name}"
  public_network_access_enabled = false
  network_acls {
    default_action = "Deny"
    virtual_network_rules {
      subnet_id = var.subnet_id
    }
  }
}


resource "azurerm_private_endpoint" "formrecognizer_pe" {
  name                = "formrecognizer_pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "text-analytics-privateserviceconnection"
    private_connection_resource_id = azurerm_cognitive_account.formrecognizer.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "formrecognizer-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.language_dns_zone.id]
  }
}


output "form_recognizer_endpoint" {
  value = azurerm_cognitive_account.formrecognizer.endpoint
}

output "formrecognizer" {
  value = azurerm_cognitive_account.formrecognizer
}
