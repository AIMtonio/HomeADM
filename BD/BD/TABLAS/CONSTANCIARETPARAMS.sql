-- CONSTANCIARETPARAMS
DELIMITER ;
DROP TABLE IF EXISTS `CONSTANCIARETPARAMS`;
DELIMITER $$

CREATE TABLE `CONSTANCIARETPARAMS` (
  `AnioProceso` int(11) NOT NULL COMMENT 'Anio proceso',
  `RutaReporte` varchar(250) NOT NULL COMMENT 'Ruta del Reporte que genera la Constancia de Retencion (.prpt)',
  `RutaExpPDF` varchar(250) NOT NULL COMMENT 'Ruta para el Alojamiento de la Constancia de Retencion',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'Numero de la Institucion',
  `RutaCBB` varchar(100) DEFAULT NULL COMMENT 'Ruta Alojamiento Codigo Binario',
  `RutaCFDI` varchar(100) DEFAULT NULL COMMENT 'Ruta Alojamiento CFDI (.xml)',
  `RutaLogo` varchar(100) DEFAULT NULL COMMENT 'Ruta de Alojamiento del Logo para mostrar en la Constancia de Retencion',
  `RutaCedula` varchar(100) DEFAULT NULL COMMENT 'Ruta de Alojamiento de la Cedula Fiscal para mostrar en la Constancia de Retencion',
  `TimbraConsRet` char(1) DEFAULT NULL COMMENT 'Campo que indica si se realizara el Timbrado para la Constancia de Retencion\nS = Si\nN =  No',
  `NumeroRegla` int(11) DEFAULT NULL COMMENT 'Numero de Regla',
  `AnioEmision` int(11) DEFAULT NULL COMMENT 'Anio de Emision de Constancias',
  `RutaETL` varchar(100) NOT NULL DEFAULT '/opt/SAFI/ConstanciaRetencion/' COMMENT 'Ruta donde se aloja la carpeta del proyecto ETL.',
  `CalcCierreIntReal` char(1) NOT NULL DEFAULT 'S' COMMENT 'Campo que indica si se realizara el calculo del Interes Real en el Cierre de Dia\nS = Si\nN =  No',
  `GeneraConsRetPDF` char(1) NOT NULL DEFAULT 'S' COMMENT 'Campo que indica si se generara la Constancia de Retencion en PDF para Socios que No tuvieron ISR en el Periodo\nS = Si\nN =  No',
  `TipoProveedorWS` int(11) NOT NULL DEFAULT '0' COMMENT 'Tipo de proveedor para realizar el timbrado:\n1.- Facturacion Moderna\n2.- Smarter Web\n3.- Hub Servicios.',
  `UsuarioWS` varchar(50) NOT NULL DEFAULT '' COMMENT 'Usuario ID para realizar la conexion con el Web Service de Timbrado.',
  `ContraseniaWS` varchar(150) NOT NULL DEFAULT '' COMMENT 'Password para realizar la conexion con el Web Service de Timbrado.',
  `UrlWSDL` varchar(200) NOT NULL DEFAULT '' COMMENT 'URL del WSDL con los Servicios de Timbrado',
  `TokenAcceso` text COMMENT 'Token de acceso el cual sera utilizado para poder timbrar(opcional depende el proveedor)\n',
  `DivideSaldoPromCta` char(1) NOT NULL DEFAULT 'S' COMMENT 'Divide el saldo promedio entre 12. S= si, N=no.',
  `RutaArchivosCertificado` varchar(500) NOT NULL DEFAULT '' COMMENT 'Ruta donde se encuentra el certficado de sello digital con su llave privada, archivos con extension .''cer'' y  ''. key'', inicia y termina con ''/''',
  `NombreCertificado` varchar(100) NOT NULL DEFAULT '' COMMENT 'Nombre de archivo certificado(CSD) con extension .cer ',
  `NombreLlavePriv` varchar(100) NOT NULL DEFAULT '' COMMENT 'Nombre de archivo llave privada(CSD) con extension .key ',
  `RutaArchivosXSLT` varchar(500) NOT NULL DEFAULT '' COMMENT 'Ruta y nombre de la plantilla XSLT para obtener la cadena original',
  `PassCertificado` varchar(100) NOT NULL DEFAULT '' COMMENT 'Contrasenia llave certificado',
  `CveRetencion` VARCHAR(2) NOT NULL DEFAULT '' COMMENT 'Clave de retencion del catalogo de SmarterWeb para la generacion de cadena de timbrado (Ej. 16 corresponde a Interes).',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`AnioProceso`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros para la Constancia de Retencion'$$