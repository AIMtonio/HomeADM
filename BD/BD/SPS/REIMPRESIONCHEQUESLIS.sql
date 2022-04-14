-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REIMPRESIONCHEQUESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `REIMPRESIONCHEQUESLIS`;DELIMITER $$

CREATE PROCEDURE `REIMPRESIONCHEQUESLIS`(
# ===============================================================
# -------- SP PARA RELIZAR LISTAS DE REIMPRESION DE CHEQUES------
# ===============================================================
	Par_InstitucionID		INT(11),
	Par_CuentaInstitucion 	BIGINT(12),
	Par_FechaEmision		DATE,
	Par_NomBeneficiario		VARCHAR(200),
	Par_CajaID				INT(11),
    Par_TipoChequera		CHAR(2),
    Par_NumLis          	TINYINT UNSIGNED,

    Par_EmpresaID      	 	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion  	BIGINT(20)
)
TerminaStore:BEGIN

	--  Declaracion de Constantes
	DECLARE Est_Emitido	 		CHAR(1);
	DECLARE Lis_CheqEmitidos 	INT(11);

	-- Asignacion de constantes
	SET Est_Emitido				:='E';
	SET Lis_CheqEmitidos     	:=1;


	IF(Par_NumLis = Lis_CheqEmitidos)THEN
		SELECT NumeroCheque, Beneficiario, Monto, Concepto
			FROM 	CHEQUESEMITIDOS
			WHERE 	InstitucionID 		= Par_InstitucionID
			AND 	CuentaInstitucion 	= Par_CuentaInstitucion
            AND		TipoChequera		= Par_TipoChequera
			AND 	CajaID 				= Par_CajaID
			AND 	FechaEmision 		= Par_FechaEmision
			AND 	Estatus 			= Est_Emitido
			AND 	Beneficiario LIKE CONCAT("%",Par_NomBeneficiario,"%")
			LIMIT 0,15;
	END IF;

END TerminaStore$$