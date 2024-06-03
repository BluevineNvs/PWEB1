#!"C:\xampp\perl\bin\perl.exe"
use strict;
use warnings;
use CGI;
use Text::CSV;
use Encode;

# Configuración de la salida
print "Content-type: text/html; charset=UTF-8\n\n";

# Crear objeto CGI
my $cgi = CGI->new;

# Obtener los parámetros del formulario
my $nombre_universidad = $cgi->param('nombre_universidad') || '';
my $periodo_licenciamiento = $cgi->param('periodo_licenciamiento') || '';
my $departamento_local = $cgi->param('departamento_local') || '';
my $denominacion_programa = $cgi->param('denominacion_programa') || '';

# Ruta al archivo CSV
my $archivo_csv = '../data/Programas_de_Universidades.csv';

# Configuración del objeto Text::CSV para usar '|' como delimitador
my $csv = Text::CSV->new({ 
    binary => 1, 
    eol => $/, 
    sep_char => '|',
    decode_utf8 => 1  # Decodificar en UTF-8 para las tildes
});

# Abrir y leer el archivo CSV
open my $fh, '<:encoding(utf8)', $archivo_csv or die "No se puede abrir el archivo CSV: $!";

# Leer las cabeceras del archivo CSV
my $header = $csv->getline($fh);

# Imprimir las cabeceras
print "<table border='1'><tr>";
print "<th>$_</th>" foreach @$header;
print "</tr>";

# Leer y mostrar los datos que coinciden con la consulta
while (my $row = $csv->getline($fh)) {
    my $nombre_universidad_match = $nombre_universidad eq '' || index(lc($row->[1]), lc($nombre_universidad)) != -1;
    my $periodo_licenciamiento_match = $periodo_licenciamiento eq '' || lc($row->[4]) eq lc($periodo_licenciamiento);
    my $departamento_local_match = $departamento_local eq '' || index(lc($row->[10]), lc($departamento_local)) != -1;
    my $denominacion_programa_match = $denominacion_programa eq '' || index(lc($row->[18]), lc($denominacion_programa)) != -1;

    if ($nombre_universidad_match && $periodo_licenciamiento_match && $departamento_local_match && $denominacion_programa_match) {
        print "<tr>";
        print "<td>$_</td>" foreach @$row;
        print "</tr>";
    }
}

print "</table>";

# Cerrar el archivo CSV
close $fh;
