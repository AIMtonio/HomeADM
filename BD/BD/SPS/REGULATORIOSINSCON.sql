-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOSINSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIOSINSCON`;DELIMITER $$

CREATE PROCEDURE `REGULATORIOSINSCON`(
	/* Consulta si un regulatorio aplica para la entidad */
    Par_ClaveReg			VARCHAR(7), 		-- Clave del Regulatorio
    Par_NumCon          	TINYINT UNSIGNED,	-- Numero de la consulta

	Par_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion		BIGINT(20)

)
TerminaStore:BEGIN
	-- variables
    DECLARE Var_TipoInsti		INT;
    DECLARE Var_NumCliente		INT;
    DECLARE Var_Aplica			CHAR(1);
    DECLARE Con_TipoRegula      VARCHAR(20);

    -- constantes
    DECLARE	Con_ValidaInst		TINYINT;	-- Valida si El regulatorio Aplica para la Institucion
	DECLARE Entero_Cero			INT;
    DECLARE Resp_SI				CHAR(1);
    DECLARE Resp_NO				CHAR(1);

	SET Con_ValidaInst			:= 1;		-- Para validar si el regulatorio pertenece a la institucion
    SET Entero_Cero				:= 0;
    SET Resp_SI					:= 'S';
    SET Resp_NO					:= 'N';
    SET Con_TipoRegula    		:= 'TipoRegulatorios';		-- Llave para obtener el tipo de Institucion financiera

    SELECT IFNULL(ValorParametro, Entero_Cero)
			INTO 	Var_TipoInsti
			FROM 	PARAMGENERALES
			WHERE 	LlaveParametro = Con_TipoRegula;

    IF Par_NumCon = Con_ValidaInst THEN
		SELECT CASE WHEN FIND_IN_SET(Var_TipoInsti,Ins.Instituciones) > Entero_Cero THEN Resp_SI ELSE Resp_NO END
        INTO Var_Aplica
        FROM REGULATORIOSINS Ins WHERE Clave = Par_ClaveReg;

        SET Var_Aplica	:= IFNULL(Var_Aplica,Resp_No);

        SELECT Par_ClaveReg AS Clave,Var_Aplica AS Aplica;

    END IF;

END TerminaStore$$