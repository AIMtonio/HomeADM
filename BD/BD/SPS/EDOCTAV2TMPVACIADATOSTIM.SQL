DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2TMPVACIADATOSTIM`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2TMPVACIADATOSTIM`(
	-- SP para la actualizacion de datos de acuerdo a la respuesta del servicio de timbrado
)
TerminaStore: BEGIN

	UPDATE EDOCTAV2TIMBRADOINGRE TimIng
		INNER JOIN EDOCTAV2RESPTIMBRE CFDI ON TimIng.ClienteID = CFDI.ClienteID AND TimIng.AnioMes = CFDI.AnioMes AND CFDI.CodigoRespuesta = '200' AND IFNULL(CFDI.CodigoRespuestaSW,'') = '000000'
		SET     TimIng.CFDIFechaEmision           = CFDI.CFDIFechaEmision,
				TimIng.CFDIVersion                = CFDI.CFDIVersion,
				TimIng.CFDINoCertSAT              = FNSALTOLINEA(CFDI.CFDINoCertSAT, 90),
				TimIng.CFDIUUID                   = FNSALTOLINEA(CFDI.CFDIUUID, 20),
				TimIng.CFDIFechaTimbrado          = CFDI.CFDIFechaTimbrado,
				TimIng.CFDISelloCFD               = FNSALTOLINEA(CFDI.CFDISelloCFD, 90),
				TimIng.CFDISelloSAT               = FNSALTOLINEA(CFDI.CFDISelloSAT, 90),
				TimIng.CFDICadenaOrig             = FNSALTOLINEA(CFDI.CFDICadenaOrig, 90),
				TimIng.CFDIFechaCertifica         = CFDI.CFDIFechaEmision,
				TimIng.CFDINoCertEmision          = CFDI.CFDINoCertEmisor,
				TimIng.CFDILugExpedicion          = CFDI.CFDILugExpedicion,
				TimIng.EstatusTimbrado			  = 2,
				TimIng.CFDITotal 				  = CFDI.CFDITotal,
				TimIng.CodigoQR					  = CFDI.CodigoQR
		WHERE TimIng.EstatusTimbrado = 1;


	UPDATE EDOCTAV2TIMBRADOINGRE EDOCTA
		INNER JOIN EDOCTAV2RESPTIMBRE CFDI ON EDOCTA.ClienteID = CFDI.ClienteID AND EDOCTA.AnioMes = CFDI.AnioMes AND CFDI.CodigoRespuesta <> '200'
		SET EDOCTA.EstatusTimbrado = 3
		WHERE EDOCTA.EstatusTimbrado = 1;

	UPDATE EDOCTAV2TIMBRADOINGRE EDOCTA
		INNER JOIN EDOCTAV2RESPTIMBRE CFDI ON EDOCTA.ClienteID = CFDI.ClienteID AND EDOCTA.AnioMes = CFDI.AnioMes AND CFDI.CodigoRespuesta = '200'  AND CFDI.CodigoRespuestaSW != '000000'
		SET EDOCTA.EstatusTimbrado = 3
		WHERE EDOCTA.EstatusTimbrado = 1;

END TerminaStore$$
