-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDADJUNTOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDADJUNTOSLIS`;DELIMITER $$

CREATE PROCEDURE `PLDADJUNTOSLIS`(
	Par_TipoProceso 				INT(11),					# Tipo de Proceso que Adjunto el Archivo. 1.- Segto Ope. Inusuales 2.- Segto Ope.Interna Preocupanes
	Par_OpeInusualID 				BIGINT(20),					# Número de la Operación Inusual
	Par_OpeInterPreoID 				INT(11),					# Número de Operacion Interna Preocupante que adjunto el archivo.
	Par_NumLis						TINYINT UNSIGNED,			# Número de Lista

	Par_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(50),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion 				BIGINT(20)
	)
TerminaStore: BEGIN

-- Declaracion de Constantes,
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero			INT;
DECLARE Lis_Principal       INT;

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';              -- Cadena Vacia
SET Fecha_Vacia			:= '1900-01-01';    -- Fecha Vacia
SET Entero_Cero			:= 0;               -- Entero Cero
SET Lis_Principal		:= 1;               -- Tipo de Lista Principal Muestra todos los archivos Adjuntos

IF(Par_NumLis = Lis_Principal OR Par_NumLis = 2) THEN
	SELECT
		AdjuntoID,			TipoProceso,		OpeInusualID,		OpeInterPreoID,		TipoDocumento,
		Consecutivo,		Observacion,		Recurso,			FechaRegistro
		FROM PLDADJUNTOS
		WHERE Estatus = 'A'
			AND TipoProceso = Par_TipoProceso
			AND ((TipoProceso = 1 AND OpeInusualID=Par_OpeInusualID) OR (TipoProceso = 2 AND OpeInterPreoID=Par_OpeInterPreoID));
END IF;

END TerminaStore$$