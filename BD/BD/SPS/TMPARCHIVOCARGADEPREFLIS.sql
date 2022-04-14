-- TMPARCHIVOCARGADEPREFLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPARCHIVOCARGADEPREFLIS`;
DELIMITER $$

CREATE PROCEDURE `TMPARCHIVOCARGADEPREFLIS`(
-- ================================================================================
-- ===== LISTA EL ARCHIVO DE CARGA TEMPORAL PARA DEPOSITOS REFERENCIADOS. =========
-- ================================================================================
	Par_InstitucionID		INT(11),			-- ID institucion bancaria
	Par_NumCtaInstit		VARCHAR(20),		-- Numero de cuenta
	Par_NumTran				BIGINT(20),			-- Numero de transaccion
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de lista

	Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Lis_Depositos	INT(11);
	DECLARE Est_Registrado	CHAR(1);

	-- Asignacion de Constantes
	SET Lis_Depositos    := 1;			-- Lista de Depositos Referenciados
	SET Est_Registrado   := 'R';

	IF(Par_NumLis  = Lis_Depositos) THEN
		SET Par_NumCtaInstit := TRIM(LEADING '0' FROM Par_NumCtaInstit);
		SELECT
			FolioCargaID, 			CuentaAhoID,   			FechaOperacionArchivo, 	 	ReferenciaMovArchivo, 		MontoMovArchivo as MontoMov,
			NatMovimientoArchivo, 	DescripcionMovArchivo,	TipoMovArchivo,	   	 		TipoDepositoArchivo, 		TipoMonedaArchivo,
			TipoCanalArchivo,     	NumIdenArchivo,			NumTransaccion,  			Validacion, 				NumVal,
			NumTransaccionCarga,	NumeroFila,				AplicarDeposito, 			NombreArchivoCarga
		FROM TMPARCHIVOCARGADEPREF
		WHERE InstitucionID = Par_InstitucionID
			AND NumCtaInstit = Par_NumCtaInstit
			AND Estatus = Est_Registrado
			AND NumTransaccionCarga = Par_NumTran;
	END IF;

END TerminaStore$$