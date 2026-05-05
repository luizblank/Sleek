import json
import sys

def main():
    file_path = 'Thrift/Localizable.xcstrings'
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    translations = {
        "Share to Sleek": {
            "pt-BR": "Compartilhar para o Sleek",
            "es": "Compartir con Sleek"
        },
        "Found something you like?\nShare an image directly to\nSleek from other apps.": {
            "pt-BR": "Encontrou algo que gostou?\nCompartilhe uma imagem de\noutros apps direto pro Sleek.",
            "es": "¿Encontraste algo que te gusta?\nComparte una imagen directamente\na Sleek desde otras apps."
        },
        "Reset customizations": {
            "pt-BR": "Resetar customizações",
            "es": "Restablecer personalizaciones"
        },
        "Reset customizations button": {
            "pt-BR": "Botão de resetar customizações",
            "es": "Botón de restablecer personalizaciones"
        },
        "Click here to reset colors, font, and background to their default values": {
            "pt-BR": "Clique aqui para resetar cores, fonte e fundo para os valores originais",
            "es": "Pulsa aquí para restablecer los colores, la fuente y el fondo a sus valores originales"
        },
        "Finish the onboarding and start using Sleek": {
            "pt-BR": "Finalize o onboarding e comece a usar o Sleek",
            "es": "Finaliza el onboarding y empieza a usar Sleek"
        },
        "Continue to the next onboarding screen": {
            "pt-BR": "Continue para a próxima tela do onboarding",
            "es": "Continúa a la siguiente pantalla del onboarding"
        }
    }

    strings = data.get("strings", {})

    for key, locs in translations.items():
        if key not in strings:
            strings[key] = {}
        if "localizations" not in strings[key]:
            strings[key]["localizations"] = {}
        
        for lang, trans_text in locs.items():
            strings[key]["localizations"][lang] = {
                "stringUnit": {
                    "state": "translated",
                    "value": trans_text
                }
            }

    data["strings"] = strings

    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

if __name__ == '__main__':
    main()
