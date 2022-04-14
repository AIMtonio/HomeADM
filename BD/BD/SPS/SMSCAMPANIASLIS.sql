-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSCAMPANIASLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSCAMPANIASLIS`;DELIMITER $$

CREATE PROCEDURE `SMSCAMPANIASLIS`(
# ========================================================
# ------------ SP PARA LISTAS LAS CAMPANIAS SMS-----------
# ========================================================
	Par_Nombre			VARCHAR(50),
	Par_NumLis			TINYINT UNSIGNED,
	Par_EmpresaID		INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Lis_Principal 			INT(11);
	DECLARE	Lis_ListaEscribirSMS 	INT(11);
	DECLARE Lis_MsgRecepcion		INT;
	DECLARE	C_Salida				CHAR(1); -- clasificacion=Salida
	DECLARE	C_Interactiva			CHAR(1);
	DECLARE	C_Campaña				CHAR(1); -- Categoria=Campaña
	DECLARE C_EstatusCan            CHAR(1);
	DECLARE C_Entrada				CHAR(1);


	SET	Lis_Principal				:= 1;		-- Lista principal
	SET	Lis_ListaEscribirSMS		:= 2;		-- Lista Para la pantalla de Escribir SMS
	SET Lis_MsgRecepcion			:= 3;
	SET C_Salida					:='S'; 		-- Clasificación = Salida
	SET C_Interactiva				:='I'; 		-- Clasificación = Interactiva
	SET C_Entrada					:='E'; 		-- Clasificación = Entrada
	SET C_Campaña					:='C'; 		-- Categoria=Campaña
	SET C_EstatusCan 				:='C'; 		-- Estatus Calncelado

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT		CampaniaID,		Nombre
			FROM 	SMSCAMPANIAS
			WHERE 	Nombre LIKE CONCAT("%", Par_Nombre, "%")
			LIMIT 	0, 15;
	END IF;

	IF(Par_NumLis = Lis_ListaEscribirSMS) THEN
		SELECT		CampaniaID,		Nombre
			FROM 	SMSCAMPANIAS
			WHERE 	Nombre LIKE CONCAT("%", Par_Nombre, "%")
			AND  	Clasificacion	!= C_Entrada
			AND		Categoria		 = C_Campaña
			AND		Estatus 		!= C_EstatusCan
			LIMIT 0, 15;
	END IF;

	IF(Par_NumLis = Lis_MsgRecepcion)THEN
		SELECT UPPER(MsgRecepcion) AS MsgRecepcion
			FROM SMSCAMPANIAS
			WHERE	Clasificacion IN (C_Entrada)
			  AND	MsgRecepcion IS NOT NULL AND MsgRecepcion != '';
	END IF;


END TerminaStore$$