-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANPUESTOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANPUESTOSLIS`;
DELIMITER $$


CREATE PROCEDURE `BANPUESTOSLIS`(
	Par_Descripcion		VARCHAR(100),		-- Parametro descripcion del puesto
	Par_Facultado		INT(11),			-- Parametro que filtra por facultado
	Par_TamanioLista	INT(11),			-- Parametro tamanio de la lista
	Par_PosicionInicial	INT(11),			-- Parametro posicion inicial de la lista

	Par_NumLis			TINYINT UNSIGNED,	-- Parametro de numero de lista

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_CantidadRegistros	INT(11);

	-- Declaracion de constantes
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Entero_Cero		INT(11);
	DECLARE Lis_Principal	INT(11);
	DECLARE Lis_xFacultado	INT(11);
	DECLARE Estatus_Vigente	CHAR(1);

	-- Asignacion de constantes
	SET Cadena_Vacia	:= '';
	SET Entero_Cero		:= 0;
	SET Lis_Principal	:= 1;
	SET Lis_xFacultado	:= 2;
	SET Estatus_Vigente	:= 'V';

	SET Par_Descripcion		:= IFNULL(Par_Descripcion, Cadena_Vacia);
	SET Par_Facultado		:= IFNULL(Par_Facultado, Entero_Cero);
	SET Par_PosicionInicial	:= IFNULL(Par_PosicionInicial, Entero_Cero);
	SET Par_TamanioLista	:= IFNULL(Par_TamanioLista, Entero_Cero);

	SELECT COUNT(*)
		INTO Var_CantidadRegistros
	FROM PUESTOS;

	IF(Par_NumLis = Lis_Principal) THEN

		SET Par_TamanioLista := Var_CantidadRegistros;

		SELECT DISTINCT P.ClavePuestoID, P.Descripcion
		FROM PUESTOS P
			WHERE P.Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
				AND P.Estatus = Estatus_Vigente
		LIMIT Par_PosicionInicial, Par_TamanioLista;

	END IF;

	IF(Par_NumLis = Lis_xFacultado) THEN

		SET Par_TamanioLista := Var_CantidadRegistros;

		SELECT DISTINCT P.ClavePuestoID, P.Descripcion
		FROM PUESTOS P
			INNER JOIN ORGANOINTEGRA O
					ON	O.ClavePuestoID = P.ClavePuestoID
			WHERE P.Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
				AND O.OrganoID = Par_Facultado
				AND P.Estatus = Estatus_Vigente
		LIMIT Par_PosicionInicial, Par_TamanioLista;

	END IF;

END TerminaStore$$