-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBOPEACLARALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBOPEACLARALIS`;DELIMITER $$

CREATE PROCEDURE `TARDEBOPEACLARALIS`(
#SP PARA LISTAR OPERACIONES DE ACLARACIONES
	Par_TipoAclaraID    INT(11),			-- Parametro de Tipo Aclaracion ID
	Par_NumLis			TINYINT UNSIGNED,	-- Parametro de Numero de Lista

	Par_EmpresaID		INT,				-- Parametro de Auditoria
	Aud_Usuario			INT,				-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT,				-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT				-- Parametro de Auditoria
	)
TerminaStore: BEGIN

-- Declaracion de Constantes
	DECLARE Cadena_Vacia        CHAR(1);	-- Cadena Vacia
	DECLARE Fecha_Vacia         DATE;		-- fecha Vacia
	DECLARE Entero_Cero			INT;		-- entero cero
	DECLARE Lis_Combo           INT;		-- Lista Combo
    DECLARE Lis_ComboCred		INT;		-- Lista Combo Credito
	DECLARE EstatusAct			CHAR(1);	-- Estatus Activo
	DECLARE TipoTarD			CHAR(1);	-- Tipo Tarjeta Debito
	DECLARE TipoTarC			CHAR(1);	-- Tipo Tarjeta Credito
	DECLARE TipoTarA			CHAR(1);	-- Tipo Tarjeta Activa
	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';              -- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero			:= 0;               -- Entero Cero
	SET Lis_Combo   		:= 1;               -- Tipo de Lista Combo
    SET Lis_ComboCred		:= 2;
	SET EstatusAct			:= 'A';
	SET TipoTarD			:= 'D';
	SET TipoTarC			:= 'C';
	SET TipoTarA			:= 'A';

	IF(Par_NumLis = Lis_Combo) THEN
		SELECT TipoAclaraID, OpeAclaraID,Descripcion,ComercioObl,CajeroObl
			FROM TARDEBOPEACLARA
			WHERE Estatus= EstatusAct
			AND TipoTarjeta = TipoTarD
			OR  TipoTarjeta = TipoTarA
			AND TipoAclaraID=Par_TipoAclaraID;
	END IF;

    IF(Par_NumLis = Lis_ComboCred) THEN
		SELECT TipoAclaraID, OpeAclaraID,Descripcion,ComercioObl,CajeroObl
			FROM TARDEBOPEACLARA
			WHERE Estatus= EstatusAct
			AND TipoTarjeta = TipoTarC
			OR  TipoTarjeta = TipoTarA
			AND TipoAclaraID=Par_TipoAclaraID;
	END IF;

END TerminaStore$$