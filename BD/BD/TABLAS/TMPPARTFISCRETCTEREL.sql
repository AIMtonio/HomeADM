-- Creacion de tabla TMPPARTFISCRETCTEREL

DELIMITER ;

DROP TABLE IF EXISTS TMPPARTFISCRETCTEREL;

DELIMITER $$

CREATE TABLE `TMPPARTFISCRETCTEREL` (
  `ConsecutivoID`       INT(11)         NOT NULL COMMENT 'ID Consecutivo',
  `ConstanciaRetID` 	BIGINT(12)		NOT NULL COMMENT 'Numero Consecutivo Constancia de Retencion',
  `Anio` 				INT(11) 		NOT NULL COMMENT 'Anio proceso',
  `ClienteID` 			INT(11) 		NOT NULL COMMENT 'Numero de Cliente',
  `Tipo` 				CHAR(2) 		NOT NULL COMMENT 'Tipo Relacionados Fiscales\nA = Aportante\nC = Cliente\nR = Relacionado\nAC = Aportante Cliente',
  `CteRelacionadoID` 	INT(11) 		NOT NULL COMMENT 'Numero del Cliente relacionado o 0 si el relacionado no es Cliente',
  `ParticipaFiscal` 	DECIMAL(14,2) 	NOT NULL COMMENT 'Indica el % que corresponde a la participacion fiscal del relacionado puede ser un valor a dos decimales en un rango del 0 al 100',
  `MontoCapital` 		DECIMAL(18,2) 	NOT NULL COMMENT 'Monto Capital (Inversion/CEDE/APORTACIONES) o Saldo promedio de la cuenta de ahorro en el anio fiscal\n',
  `MontoTotOperacion` 	DECIMAL(18,2) 	NOT NULL COMMENT 'Monto Total de Operacion en el anio fiscal (Inversiones,Cuentas,Cedes,Aportaciones)',
  `MontoTotGrav` 		DECIMAL(18,2) 	NOT NULL COMMENT 'Monto Total Interes Gravado en el anio fiscal (Inversiones,Cuentas,Cedes,Aportaciones)',
  `MontoTotExent` 		DECIMAL(18,2) 	NOT NULL COMMENT 'Monto Total Interes Exento en el anio fiscal (Inversiones,Cuentas,Cedes,Aportaciones)',
  `MontoTotRet` 		DECIMAL(18,2) 	NOT NULL COMMENT 'Monto Total Retenciones en el anio fiscal (Inversiones,Cuentas,Cedes,Aportaciones)',
  `MontoIntReal` 		DECIMAL(18,2) 	NOT NULL COMMENT 'Monto Total Interes Real en el anio fiscal (Inversiones,Cuentas,Cedes,Aportaciones)',
  `TipoPersona` 		CHAR(1) 		NOT NULL COMMENT 'Tipo de Personalidad del Cliente\nM = Persona Moral\nA = Persona Fisica Con Actividad Empresarial\nF = Persona Fisica Sin Actividad Empresarial',
  `RFC` 				VARCHAR(13) 	NOT NULL COMMENT 'Registro Federal de Contribuyentes',
  `RegHacienda` 		CHAR(1) 		NOT NULL COMMENT 'Especifica si el cliente esta registrado en Hacienda\nS.- Si\nN.- No',
  `NombreCompleto` 		VARCHAR(200) 	NOT NULL COMMENT 'Nombre Completo del Cliente o Razon Social',
  `EmpresaID`           INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario`             INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual`         DATETIME        NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP`         VARCHAR(15)     NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID`          VARCHAR(50)     NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal`            INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion`      BIGINT(20)      NOT NULL COMMENT 'Parametro de Auditoria',
   PRIMARY KEY (`ConsecutivoID`),
  KEY `INDEX_TMPPARTFISCRETCTEREL_1` (`ConstanciaRetID`),
  KEY `INDEX_TMPPARTFISCRETCTEREL_2` (`Anio`),
  KEY `INDEX_TMPPARTFISCRETCTEREL_3` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para el Registro de Personas Relacionadas que sean Clientes y no generaron Intereses en el periodo'$$
