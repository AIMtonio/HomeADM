-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REMESACATALOGOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `REMESACATALOGOLIS`;
DELIMITER $$


CREATE PROCEDURE `REMESACATALOGOLIS`(
	Par_Nombre			VARCHAR(200),
	Par_NumLis			INT(11),

	Par_EmpresaID       		INT,
	Aud_Usuario         		INT,
	Aud_FechaActual  	   	DATETIME,
	Aud_DireccionIP    	 	VARCHAR(15),
	Aud_ProgramaID   	   	VARCHAR(50),
	Aud_Sucursal        		INT,
	Aud_NumTransaccion  	BIGINT
	)

TerminaStore: BEGIN


DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Estatus_Activo	CHAR(2);					-- Estatus Activo Remesa

DECLARE	Lis_Principal	INT;
DECLARE	Lis_Combo		INT;


SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET Estatus_Activo		:= 'A';
SET Lis_Principal		:= 1;
SET Lis_Combo			:= 2;

IF(Par_NumLis = Lis_Principal) THEN
	SELECT 	RemesaCatalogoID,	Nombre,	NombreCorto, 	CuentaCompleta
			FROM REMESACATALOGO
			WHERE 	(Nombre LIKE concat("%",Par_Nombre,"%") OR NombreCorto LIKE concat("%",Par_Nombre,"%"));
END IF;


IF(Par_NumLis = Lis_Combo) THEN
	SELECT 	RemesaCatalogoID,	Nombre,	NombreCorto, 	CuentaCompleta
		FROM REMESACATALOGO
        WHERE Estatus = Estatus_Activo;
END IF;


END TerminaStore$$