-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANPAISESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANPAISESLIS`;
DELIMITER $$
CREATE PROCEDURE `BANPAISESLIS`(
    -- Lista de Paises --
	Par_Nombre		    VARCHAR(50),			-- Nombre del pais
	Par_NumLis		    TINYINT UNSIGNED, 		-- Numero de lista
	Par_TamanioLista		INT(11),			-- Parametro tamanio de la lista
	Par_PosicionInicial		INT(11),			-- Parametro posicion inicial de la lista
	
    
    Aud_EmpresaID		INT, 					-- Auditoria
	Aud_Usuario			INT,					-- Auditoria
	Aud_FechaActual		DATETIME,				-- Auditoria
	Aud_DireccionIP		VARCHAR(15),			-- Auditoria
	Aud_ProgramaID		VARCHAR(50),			-- Auditoria
	Aud_Sucursal		INT,					-- Auditoria
	Aud_NumTransaccion	BIGINT					-- Auditoria
	)

TerminaStore: BEGIN

-- Declaracion d evariables
DECLARE Var_CantidadRegistro	INT(11);	-- Variable para Guardar  la cantidad de registro


DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena vacia
DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
DECLARE	Entero_Cero			INT;			-- Entero con valor cero
DECLARE	Entero_Uno			INT;			-- Entero con valor uno
DECLARE	Lis_Principal		INT;			-- Lista devuelve el catalogo de paises
DECLARE Lis_Nombre			INT;			-- Lista devuelve las coincidencias por nombre

SET	Cadena_Vacia		:= '';				-- Cadena vacia
SET	Fecha_Vacia 		:= '1900-01-01';	-- Fecha Vacia
SET	Entero_Cero	    	:= 0;				-- Entero cero
SET Entero_Uno			:= 1;				-- Entero con valor uno
SET	Lis_Principal		:= 1;				-- Asignacion lista principal, devuelve el catalogo de paises
SET Lis_Nombre			:= 2;				-- Asignacion lista por nombre

SET Par_TamanioLista 		:= IFNULL(Par_TamanioLista, Entero_Cero);
SET Par_PosicionInicial 	:= IFNULL(Par_PosicionInicial, Entero_Cero);
SET Par_Nombre				:= IFNULL(Par_Nombre, Cadena_Vacia);

IF(Par_NumLis = Lis_Principal) THEN
	SELECT	`PaisID`,		`Nombre`, 	`PrefijoTelef`	
	FROM PAISES
	ORDER BY Nombre;
END IF;

IF(Par_NumLis = Lis_Nombre) THEN
	SELECT      COUNT(*)
		INTO    Var_CantidadRegistro
		FROM PAISES;

	IF(Par_TamanioLista <= Entero_Cero) THEN
		SET Par_TamanioLista := Var_CantidadRegistro;
	END IF;
	
	IF(Par_PosicionInicial < Entero_Cero) THEN
		SET Par_PosicionInicial := Entero_Cero;
	END IF;

	SELECT	`PaisID`,		`Nombre`, 	`PrefijoTelef`
		FROM PAISES
		WHERE Nombre LIKE CONCAT("%",Par_Nombre,"%")
		ORDER BY Nombre
		LIMIT Par_PosicionInicial, Par_TamanioLista;
END IF;

END TerminaStore$$ 
