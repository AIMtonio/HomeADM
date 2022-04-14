-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARCHIVOCARGADEPREFLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARCHIVOCARGADEPREFLIS`;
DELIMITER $$


CREATE PROCEDURE `ARCHIVOCARGADEPREFLIS`(
	/* LISTA EL ARCHIVO DE CARGA PARA DEPÓSITOS REFERENCIADOS. */
	Par_InstitucionID		INT(11),			-- ID DE LA INSTITUCIÓN BANCARIA.
	Par_NumCtaInstit		VARCHAR(20),		-- NÚMERO DE CTA DE LA INST. BANCARIA.
	Par_NumTran				BIGINT(20),			-- NÚMERO DE TRANSACCIÓN.
	Par_NumLis				TINYINT UNSIGNED,	-- TIPO DE LISTA.
	/* Parámetros de Auditoría. */
	Par_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN

/* Declaracion de Constantes */
DECLARE Lis_Depositos	INT;
DECLARE Estatus_NoIden  CHAR(2);

/* Asignacion de Constantes */
SET Lis_Depositos    := 1;			-- Lista de Depositos Referenciados
SET Estatus_NoIden   := 'NI';		-- Estatus No Identificado.

IF(Par_NumLis  = Lis_Depositos) THEN
  	SELECT
		FolioCargaID, 	CuentaAhoID,   		FechaAplica,  	 ReferenciaMov, 	FORMAT(MontoMov,2) as MontoMov,
		NatMovimiento, 	DescripcionMov,		TipoMov,	   	 TipoDeposito, 		MonedaID,
		TipoCanal,     	NumIdenArchivo,		NumTransaccion,  Validacion, 		NumVal,
        NumTran
		FROM ARCHIVOCARGADEPREF
			WHERE InstitucionID = Par_InstitucionID
				AND CuentaAhoID = Par_NumCtaInstit
				AND Estatus = Estatus_NoIden
				AND NumTran = Par_NumTran;
END IF;

END TerminaStore$$