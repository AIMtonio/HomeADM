DELIMITER ;
DROP TABLE IF EXISTS `PLDSEGPERSONALISTAS`;
DELIMITER $$
CREATE TABLE `PLDSEGPERSONALISTAS` (
  `OpeInusualID` BIGINT(20) NOT NULL COMMENT 'Identificador de la tala PLDOPEINUSUALES',
  `TipoPersona` CHAR(5) NULL COMMENT 'Indica si la persona que hizo deteccion en la LPB es prospecto/cliente/aval/relacionado/proveedor',
  `NumRegistro` BIGINT(20) NULL COMMENT 'Indica el numero de prospecto/cliente/aval/relacionado/proveedor al que corresponde la deteccion realizada',
  `Nombre` VARCHAR(300) NULL COMMENT 'Indica el nombre del prospecto/cliente/aval/relacionado/proveedor al que corresponde la deteccion realizada',
  `FechaDeteccion` DATE NULL COMMENT 'indica la fecha en que se hizo la deteccion.',
  `ListaDeteccion` VARCHAR(45) NULL COMMENT 'Indica la lista en la cual se hizo la deteccion.',
  `NombreDet` VARCHAR(300) NULL COMMENT 'Indica los nombres que tenia la persona detectada al momento de la deteccion.',
  `ApellidoDet` VARCHAR(300) NULL COMMENT 'indica los apellidos que tenia la persona detectada al momento de la deteccion.',
  `FechaNacimientoDet` DATE NULL COMMENT 'Indica la fecha de nacimiento que tenia la persona detectada al momento de la deteccion.',
  `RFCDet` VARCHAR(13) NULL COMMENT ' Indica el Registro Federal de Contribuyente que tenia la persona detectada al momento de la deteccion.',
  `PaisDetID` INT(11) NULL COMMENT 'Indica el pais que tenia la persona detectada al momento de la deteccion',
  `PermiteOperacion` CHAR(1) NULL COMMENT 'Indica si el cliente ligado al folio consultado podra continuar con sus operaciones en el sistema al despues del analisis que realice el area de cumplimiento.\n\nS = SI\nN = NO',
  `Comentario` VARCHAR(400) NULL COMMENT 'En este el oficial de cumplimiento agregara los comentarios de su revision.',
  `EmpresaID` INT(11) NULL DEFAULT NULL COMMENT 'Parametros de auditoria',
  `Usuario` INT(11) NULL DEFAULT NULL COMMENT 'Parametros de auditoria',
  `FechaActual` DATETIME NULL DEFAULT NULL COMMENT 'Parametros de auditoria',
  `DireccionIP` VARCHAR(15) NULL DEFAULT NULL COMMENT 'Parametros de auditoria',
  `ProgramaID` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Parametros de auditoria',
  `Sucursal` INT(11) NULL DEFAULT NULL COMMENT 'Parametros de auditoria',
  `NumTransaccion` BIGINT(20) NULL DEFAULT NULL COMMENT 'Parametros de auditoria',
  PRIMARY KEY (`OpeInusualID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Tab.- Tabla para almacenar la informacion de la pantalla de Seguimiento de personas en listas'$$
