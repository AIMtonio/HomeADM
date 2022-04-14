-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANMONEDASLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANMONEDASLIS`;
DELIMITER $$


CREATE PROCEDURE `BANMONEDASLIS`(
	Par_MonedaId			INT(11),			-- MonedaId
	Par_Descripcion			VARCHAR(100),		-- Descripcion de la moneda
	Par_DescriCorta			VARCHAR(50),		-- Descripcion corta del tipo de moneda ej, MXN
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de lista
	Par_TamanioLista		INT(11),			-- Parametro tamanio de la lista
	Par_PosicionInicial		INT(11),			-- Parametro posicion inicial de la lista

	Aud_EmpresaID			INT,				-- Auditoria
	Aud_Usuario				INT,				-- Auditoria
	Aud_FechaActual			DATETIME,			-- Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Auditoria
	Aud_Sucursal			INT,				-- Auditoria
	Aud_NumTransaccion		BIGINT				-- Auditoria
	)

TerminaStore: BEGIN
-- Declaracion de evariables
DECLARE Var_CantidadRegistro	INT(11);	-- Variable para Guardar  la cantidad de registro

DECLARE	Cadena_Vacia			CHAR(1);	-- Cadena vacia
DECLARE	Fecha_Vacia				DATE;		-- Fecha Vacia
DECLARE	Entero_Cero				INT;		-- Entero cero
DECLARE	Lis_Principal 			INT;		-- Lista principal

Set	Cadena_Vacia				:= '';
Set	Fecha_Vacia					:= '1900-01-01';
Set	Entero_Cero					:= 0;
Set Lis_Principal				:= 1;

SET Par_TamanioLista 		:= IFNULL(Par_TamanioLista, Entero_Cero);
SET Par_PosicionInicial 	:= IFNULL(Par_PosicionInicial, Entero_Cero);
SET Par_Descripcion			:= IFNULL(Par_Descripcion, Cadena_Vacia);
SET Par_MonedaId			:= IFNULL(Par_MonedaId, Entero_Cero);
SET Par_DescriCorta			:= IFNULL(Par_DescriCorta, Cadena_Vacia);


IF(Par_NumLis = Lis_Principal) THEN

	SELECT COUNT(*)
		INTO Var_CantidadRegistro
	FROM MONEDAS;
	
	IF(Par_TamanioLista = Entero_Cero) THEN
		SET Par_TamanioLista		:= Var_CantidadRegistro;
	END IF;

	SELECT MonedaId, Descripcion, DescriCorta
		FROM MONEDAS
        WHERE DescriCorta LIKE CONCAT("%",Par_DescriCorta,"%")
		AND MonedaId = IF(Par_MonedaId <> Entero_Cero, Par_MonedaId, MonedaId)
        AND Descripcion LIKE CONCAT("%",Par_Descripcion,"%")
		LIMIT Par_PosicionInicial, Par_TamanioLista;
END IF;
END TerminaStore$$ 
