DELIMITER ;
DROP PROCEDURE IF EXISTS `BANSUCURSALESLIS`;
DELIMITER $$
CREATE PROCEDURE `BANSUCURSALESLIS`(

	Par_NombreSucur		VARCHAR(50),
	Par_RegionID		INT(11),
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


	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Lis_Principal 		INT(11);

    DECLARE Est_Aperturada		CHAR(1);


	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Lis_Principal		:= 1;

	SET Est_Aperturada		:= 'A';

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	SucursalID,		NombreSucurs,		DirecCompleta,		Telefono,		Latitud,
				Longitud
		FROM SUCURSALES
		WHERE Estatus = Est_Aperturada;
	END IF;

END TerminaStore$$