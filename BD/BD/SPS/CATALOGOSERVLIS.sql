-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATALOGOSERVLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATALOGOSERVLIS`;
DELIMITER $$


CREATE PROCEDURE `CATALOGOSERVLIS`(



 	Par_CatalogoSerID	INT(11),
	Par_NombreServicio	VARCHAR(50),
	Par_NumLis			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT
		)

TerminaStore:BEGIN

	DECLARE	Estatus_Activo	CHAR(2);					-- Estatus Activo Servicio
	DECLARE List_Principal		INT;
	DECLARE List_Combo			INT;
	DECLARE List_ComboWS		INT;
	DECLARE List_ServReqCliente	INT;
	DECLARE List_TiposServGral	INT(11);				-- Lista los Tipos de Servicios activos e inactivos
    
    DECLARE Var_VentanillaSI	CHAR(1);
	DECLARE Var_VentanillaNO	CHAR(1);

	SET Estatus_Activo			:= 'A';
	SET List_Principal			:= 1;
	SET List_Combo				:= 2;
	SET List_ComboWS 			:= 3;
	SET List_ServReqCliente		:= 4;
    SET List_TiposServGral		:= 5;

    SET Var_VentanillaNO		:= 'N';
	SET Var_VentanillaSI		:= 'S';

	IF(Par_NumLis = List_Principal) THEN
		SELECT	CatalogoServID,	NombreServicio
			FROM CATALOGOSERV
			WHERE	NombreServicio LIKE CONCAT("%", Par_NombreServicio, "%")
			LIMIT 15;
	END IF;

	IF(Par_NumLis = List_Combo)THEN
		SELECT	CatalogoServID,	NombreServicio
			FROM CATALOGOSERV
            WHERE	Ventanilla = Var_VentanillaSI
            AND		Estatus = Estatus_Activo;
	END IF;

	IF(Par_NumLis = List_ComboWS) THEN
		SELECT	CatalogoServID,	NombreServicio
			FROM CATALOGOSERV
            WHERE	BancaElect	= 'S';
	END IF;

	IF(Par_NumLis = List_ServReqCliente) THEN
		SELECT	CatalogoServID,	NombreServicio
			FROM CATALOGOSERV
			WHERE	NombreServicio LIKE CONCAT("%", Par_NombreServicio, "%")
			  AND	RequiereCliente	= "S"
			LIMIT 15;
	END IF;
	
	IF(Par_NumLis = List_TiposServGral)THEN
		SELECT	CatalogoServID,	NombreServicio
			FROM CATALOGOSERV
            WHERE	Ventanilla = Var_VentanillaSI;
	END IF;

END TerminaStore$$