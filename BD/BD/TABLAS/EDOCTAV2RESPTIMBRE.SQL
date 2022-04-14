DELIMITER ;
DROP TABLE IF EXISTS EDOCTAV2RESPTIMBRE;
DELIMITER $$

CREATE TABLE EDOCTAV2RESPTIMBRE (
  FechaRegistro DATETIME NOT NULL DEFAULT NOW(),
  ClienteID               INT  NOT NULL,
  AnioMes                 INT  NOT NULL,
  SucursalID              INT  NOT NULL,
  CodigoRespuesta         VARCHAR(10) NOT NULL DEFAULT '0',
  CodigoRespuestaSW       VARCHAR(10) NOT NULL DEFAULT '0',
  RespuestaWS TEXT  NULL,
  xmlSat TEXT NULL,
  CodigoQR TEXT NULL,
  CFDIFechaEmision       DATE            NULL,
  CFDIVersion            VARCHAR(10)     NULL,
  CFDINoCertSAT          VARCHAR(50)     NULL,
  CFDIUUID               VARCHAR(400)    NULL,
  CFDIFechaTimbrado      VARCHAR(50)     NULL,
  CFDISelloSAT           VARCHAR(2000)   NULL,
  CFDICadenaOrig         VARCHAR(2000)   NULL,
  CFDINoCertEmisor       VARCHAR(400)    NULL,
  CFDILugExpedicion      VARCHAR(400)    NULL,
  CFDISelloCFD           VARCHAR(2000)   NULL,
  CFDITotal		         DECIMAL(14,2) 	 NULL,
  RegistroID BIGINT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY(RegistroID),
  KEY `IDX_EDOCTATMPRESPTIMBRE_1` (`ClienteID`),
  KEY `IDX_EDOCTATMPRESPTIMBRE_2` (ClienteID, AnioMes),
  KEY `IDX_EDOCTATMPRESPTIMBRE_3` (AnioMes, SucursalID, CodigoRespuesta),
  KEY `IDX_EDOCTATMPRESPTIMBRE_4` (`CodigoRespuesta`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para registrar las respuestas del consumo del servicio de timbrado'$$
