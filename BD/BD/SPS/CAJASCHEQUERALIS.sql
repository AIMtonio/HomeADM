-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASCHEQUERALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASCHEQUERALIS`;DELIMITER $$

CREATE PROCEDURE `CAJASCHEQUERALIS`(
# =================================================================
# -------- SP QUE LISTA LOS FOLIOS ASIGNADOS EN CAJASCHEQUERA------
# =================================================================
	Par_SucursalID		INT(11),			-- Numero de la sucursal
	Par_CajaID			INT(11),			-- Numero de la caja
	Par_InstitucionID	INT(11),			-- Numero de la institucion bancaria
    Par_NumCtaInstit	VARCHAR(20),		-- Numero de la cuenta bancaria
    Par_TipoChequera	CHAR(2),			-- Tipo de chequera E- Estandar P-Proforma

	Par_NumLis			TINYINT UNSIGNED,	-- Numero de lista

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT(11);
	DECLARE EstatusA				CHAR(1);
	DECLARE	Lis_CheqCaja			INT(11);
	DECLARE Lis_CtasCheqCan			INT(11);
	DECLARE Lis_ChequeraSucursal	INT(11);
	DECLARE Con_ChequeraSI			CHAR(1);

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;		-- Entero Cero
	SET Cadena_Vacia				:= '';		-- Cadena Vacia
	SET EstatusA					:= 'A';		-- Estatus de chequera: A.- Asignada
	SET Lis_CheqCaja				:= 2;		-- Lista las chequeras de una caja
	SET Lis_CtasCheqCan				:= 6;		-- Lista los numeros de Cuenta que manejan Chequera
	SET Lis_ChequeraSucursal		:= 7; 		-- Lista las chequeras por sucursal
	SET Con_ChequeraSI				:= 'S';		-- Si cuenta con chequera

	/*
		Numero de Lista: 2
		Usado en: Ventanilla -> Registro -> Ingresos de Operaciones
		Para listar las chequeras disponibles de la caja
	*/
	IF (Par_NumLis = Lis_CheqCaja) THEN
		SELECT		CC.InstitucionID, CC.NumCtaInstit ,
					CONCAT(CONVERT(CC.InstitucionID,CHAR),"-", CC.NumCtaInstit) AS InstitucionCta,
					CONCAT(IT.NombreCorto," - ",SucursalInstit," - ", CA.NumCtaInstit) AS DescripLista
			FROM 	CAJASCHEQUERA CC
					INNER JOIN INSTITUCIONES IT	 ON CC.InstitucionID = IT.InstitucionID
					INNER JOIN CUENTASAHOTESO CA ON IT.InstitucionID = CA.InstitucionID
					AND CC.NumCtaInstit = CA.NumCtaInstit
			WHERE   CC.CajaID	 	= Par_CajaID
			AND 	CC.SucursalID	= Par_SucursalID
			AND 	CC.Estatus		= EstatusA
			AND 	CA.Chequera 	= Con_ChequeraSI
            GROUP BY CC.NumCtaInstit, CC.InstitucionID;
	END IF;

	/*
		Numero de Lista: 6
		Usado en: Tesoreria -> Bancos -> Cancelacion Cheques
		Para listar NÃºmeros de Cuenta que manejan Chequera,
		se usa en la pantalla de cancelacion de cheques(emitidos en ventanilla)
	*/
	IF(Par_NumLis = Lis_CtasCheqCan) THEN
		SELECT	 	CC.NumCtaInstit,  CA.SucursalInstit
			FROM 	CAJASCHEQUERA CC
					INNER JOIN INSTITUCIONES IT  ON CC.InstitucionID = IT.InstitucionID
					INNER JOIN CUENTASAHOTESO CA ON IT.InstitucionID = CA.InstitucionID
                    AND CC.NumCtaInstit =CA.NumCtaInstit
			WHERE   CC.CajaID	 		= Par_CajaID
			AND 	CC.SucursalID		= Par_SucursalID
			AND 	CC.Estatus			= EstatusA
			AND 	CA.Chequera 		= Con_ChequeraSI
			AND 	CA.Estatus			= EstatusA
			AND 	IT.InstitucionID	= Par_InstitucionID
            GROUP BY CC.NumCtaInstit, CA.SucursalInstit
			LIMIT 	0,15;
	END IF;

	/*
		Numero de Lista: 7
		Usado en: Tesoreria -> Bancos -> Asignacion de Chequeras a Suc.
		Para listar las sucursales y sus chequeras mostrandolas en el grid
	*/
	IF(Par_NumLis = Lis_ChequeraSucursal)THEN
		SELECT		CC.SucursalID, SU.NombreSucurs, CC.CajaID, CC.DescripcionCaja, IFNULL(CC.FolioCheqInicial,Cadena_Vacia) AS FolioCheqInicial,
					IFNULL(CC.FolioCheqFinal,Cadena_Vacia) AS FolioCheqFinal, CC.Estatus, CC.FolioUtilizar
			FROM 	CAJASCHEQUERA CC
					INNER JOIN INSTITUCIONES IT  ON CC.InstitucionID = IT.InstitucionID
					INNER JOIN CUENTASAHOTESO CA ON IT.InstitucionID = CA.InstitucionID AND CC.NumCtaInstit =CA.NumCtaInstit
					INNER JOIN SUCURSALES SU ON CC.SucursalID = SU.SucursalID
			WHERE   CC.Estatus		 	= EstatusA
			AND 	CA.Chequera 	 	= Con_ChequeraSI
			AND 	CA.Estatus		 	= EstatusA
			AND 	IT.InstitucionID	= Par_InstitucionID
			AND 	CC.NumCtaInstit  	= Par_NumCtaInstit
            AND 	CC.TipoChequera		= Par_TipoChequera
			ORDER BY CC.FolioCheqInicial;
	END IF;

END TerminaStore$$