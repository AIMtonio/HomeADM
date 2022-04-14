-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITUCIONESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `INSTITUCIONESLIS`;DELIMITER $$

CREATE PROCEDURE `INSTITUCIONESLIS`(
# =====================================================
# ------- STORED DE LISTA DE INSTITUCIONES ---------
# =====================================================
	Par_Nombre				VARCHAR(20),	-- Nombre de la descripcion
	Par_NumLis				TINYINT UNSIGNED,-- Numero de lista

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Lis_Principal 		INT(11);
	DECLARE	Lis_Combo	 		INT(11);

	DECLARE Lis_PorSucursal		INT(11);
	DECLARE Lis_ParticipaSpei   INT(11);
	DECLARE Lis_InstitTeso      INT(11);
	DECLARE Lis_BusquedaWS		INT(11);
	DECLARE Lis_DepRef			INT(11);

	-- SIGNACION DE CONSTANTES
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Lis_Principal		:= 1;
	SET	Lis_Combo			:= 2;

	SET Lis_PorSucursal 	:= 3;
	SET Lis_ParticipaSpei 	:= 4;
	SET Lis_InstitTeso    	:= 5;
	SET Lis_BusquedaWS	  	:= 6;
	SET Lis_DepRef	  		:= 7;

	-- Lista 1 Principal
	IF(Par_NumLis = Lis_Principal) THEN

		SELECT	`InstitucionID`,	`Nombre` ,	`NombreCorto`
		FROM INSTITUCIONES
		WHERE  NombreCorto LIKE CONCAT("%", Par_Nombre, "%")
		LIMIT 0, 15;

	END IF;

	-- Lista 3 de instit. donde la sucursal tiene cuentas
	IF(Par_NumLis = Lis_PorSucursal) THEN

		SELECT DISTINCT Cta.InstitucionID AS `InstitucionID` ,Ins.Nombre AS `Nombre` ,Ins.NombreCorto AS `NombreCorto`
		FROM CUENTASAHOSUCUR Cta, INSTITUCIONES Ins
        WHERE Cta.SucursalID=Aud_Sucursal
			AND Cta.InstitucionID=Ins.InstitucionID
            AND  Ins.NombreCorto LIKE CONCAT("%",Par_Nombre, "%")
		LIMIT 0, 15;

	END IF;

	-- Lista 4
	IF(Par_NumLis = Lis_ParticipaSpei) THEN

		SELECT	InstitucionID, ClaveParticipaSpei, Nombre, NombreCorto
		FROM INSTITUCIONES
		WHERE  NombreCorto LIKE CONCAT("%", Par_Nombre, "%")
			AND ClaveParticipaSpei != Entero_Cero
		LIMIT 0, 15;

	END IF;

	-- Lista 5
	IF(Par_NumLis = Lis_InstitTeso) THEN

		SELECT	ins.InstitucionID, ins.Nombre, ins.NombreCorto
		FROM INSTITUCIONES ins, CUENTASAHOTESO ct
		WHERE ins.InstitucionID = ct.InstitucionID
			AND  NombreCorto LIKE CONCAT("%", Par_Nombre, "%")
		GROUP BY InstitucionID, ins.Nombre, ins.NombreCorto
		LIMIT 0, 15;

	END IF;

	-- Lista 6
	IF(Par_NumLis = Lis_BusquedaWS) THEN

		SELECT	InstitucionID, ClaveParticipaSpei, Nombre, NombreCorto
		FROM INSTITUCIONES
		WHERE  NombreCorto LIKE CONCAT("%", Par_Nombre, "%")
			OR Nombre LIKE CONCAT("%", Par_Nombre, "%")
		LIMIT 0, 15;

	END IF;

	--  Lista 7 Depositos Referenciados
	IF(Par_NumLis = Lis_DepRef) THEN

		SELECT	`InstitucionID`, `Nombre` ,`NombreCorto`
		FROM INSTITUCIONES
		WHERE  NombreCorto LIKE CONCAT("%", Par_Nombre, "%")
			OR Nombre LIKE CONCAT("%", Par_Nombre, "%")
		LIMIT 0, 15;

	END IF;

END TerminaStore$$