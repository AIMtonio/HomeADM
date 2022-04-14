-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANESTADOSREPUBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANESTADOSREPUBLIS`;
DELIMITER $$

CREATE PROCEDURE `BANESTADOSREPUBLIS`(
	Par_EstadoID			INT(11),				-- Numero de Estado
	Par_NombreEstado		VARCHAR(50),			-- Descripcion o nombre del estado
	Par_TamanioLista		INT(11),				-- Parametro tamanio de la lista
	Par_PosicionInicial		INT(11),				-- Parametro posicion inicial de la lista
	Par_NumLis				TINYINT UNSIGNED,		-- Numero de listado
	Aud_EmpresaID			INT(11),				-- Parametro de auditoria

	Aud_Usuario				INT(11),				-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal			INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de Auditoria

		)
TerminaStore: BEGIN

	-- Declaracion de constante
	DECLARE	Cadena_Vacia		CHAR(1);			-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero			INT(11);			-- Entero Cero
	DECLARE	Lis_Principal		INT(11);			-- Numero de listado de los estado para el ws de milagro

	-- Asignacion de constante
	SET	Cadena_Vacia			:= '';				-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Entero Cero

	SET	Lis_Principal			:= 1;				-- Numero de listado de los estados para el ws de milagro

	SET Par_EstadoID			:= IFNULL(Par_EstadoID, Entero_Cero);
	SET Par_TamanioLista		:= IFNULL(Par_TamanioLista, Entero_Cero);
	SET Par_PosicionInicial		:= IFNULL(Par_PosicionInicial, Entero_Cero);
	SET Par_NombreEstado		:= IFNULL(Par_NombreEstado, Cadena_Vacia);

	-- 1.-Numero de listado de los estados para el ws de milagro
	IF(Par_NumLis = Lis_Principal) THEN
		IF(Par_TamanioLista = Entero_Cero) THEN
			SELECT COUNT(EstadoID)
				INTO Par_TamanioLista
					FROM ESTADOSREPUB;
		END IF;

		SELECT	EstadoID,			Nombre,			EqBuroCred,			EqCirCre,				Clave
		FROM ESTADOSREPUB
		WHERE EstadoID = IF(Par_EstadoID > Entero_Cero, Par_EstadoID, EstadoID)
		AND Nombre LIKE CONCAT("%", Par_NombreEstado, "%")
		LIMIT Par_PosicionInicial, Par_TamanioLista;
	END IF;

END TerminaStore$$