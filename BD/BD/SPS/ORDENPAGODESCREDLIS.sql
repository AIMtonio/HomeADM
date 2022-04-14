-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORDENPAGODESCREDLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ORDENPAGODESCREDLIS`;DELIMITER $$

CREATE PROCEDURE `ORDENPAGODESCREDLIS`(
# ============================================================
# ----- SP PARA LISTAR ORDENES DE PAGO DE DISPERSIONES-----
# ============================================================
	Par_InstitucionID		INT(11),			-- Numero de institucion
	Par_NumCtaInstit		VARCHAR(20),		-- Cuenta de institucion
	Par_NumOrdenPago		VARCHAR(25),		-- Numero de Orden de pago
    Par_NumLis          	TINYINT UNSIGNED,	-- Numero de lista

   	/* Parametros de Auditoria */
    Par_EmpresaID      	 	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion  	BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_Sentencia		VARCHAR(60000);		-- Variable para la consulta

	-- Declaracion de contantes
	DECLARE EnteroCero			INT(11);
	DECLARE Cadena_Vacia		CHAR(1);
    DECLARE Fecha_Vacia			DATE;
	DECLARE Lis_TodosEmitidos	INT(11);
	DECLARE	Var_EstatusEmi		CHAR(1);


	-- Asignacion de Contantes
	SET EnteroCero				:= 0;				-- Entero cero
	SET Cadena_Vacia			:= '';				-- Cadena vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET Lis_TodosEmitidos		:= 1;				-- Lista de ordenes emitidas
	SET	Var_EstatusEmi			:= 'E';


	IF(Par_NumLis = Lis_TodosEmitidos)THEN
		SELECT	NumOrdenPago,	Beneficiario,	Monto,	Fecha
			FROM ORDENPAGODESCRED
			WHERE 	InstitucionID 	= Par_InstitucionID
			  AND 	NumCtaInstit	= Par_NumCtaInstit
			  AND	Estatus			= Var_EstatusEmi
			  AND 	NumOrdenPago LIKE CONCAT("%",Par_NumOrdenPago,"%")
			LIMIT 0,15;
	END IF;

END TerminaStore$$