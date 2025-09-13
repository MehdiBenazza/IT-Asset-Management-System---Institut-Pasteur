import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
	/// Crée un PDF à partir d'un titre et d'un contenu
	Future<Uint8List> createPdf({required String title, required String content}) async {
		final pdf = pw.Document();
		pdf.addPage(
			pw.Page(
				build: (pw.Context context) => pw.Column(
					crossAxisAlignment: pw.CrossAxisAlignment.start,
					children: [
						pw.Text(title, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
						pw.SizedBox(height: 16),
						pw.Text(content, style: pw.TextStyle(fontSize: 14)),
					],
				),
			),
		);
		return pdf.save();
	}

	/// Partage un PDF (Uint8List) via les options natives
	Future<void> sharePdf(Uint8List pdfBytes, {String? fileName}) async {
		final name = fileName ?? 'document.pdf';
		await Printing.sharePdf(bytes: pdfBytes, filename: name);
		// Optionnel: Utiliser Share.shareXFiles pour partager le fichier si besoin
	}

	/// Imprime un PDF (Uint8List) via les options natives
	Future<void> printPdf(Uint8List pdfBytes) async {
		await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
	}
}
