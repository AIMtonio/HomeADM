-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASCHEQUERACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASCHEQUERACON`;
DELIMITER $$

CREATE PROCEDURE `CAJASCHEQUERACON`(
# =====================================================================
# -------- SP QUE CONSULTA LOS FOLIOS ASIGNADOS EN CAJASCHEQUERA ------
# =====================================================================
	Par_InstitucionID		INT(11),			-- Numero de la Institucion Bancaria
	Par_NumCtaInstit		VARCHAR(20),		-- Numero de la cuenta institucional bancaria
	Par_SucursalID			INT(11),			-- Numero de la sucursal a consultar
	Par_CajaID				INT(11),			-- Numero de la caja a consultar
    Par_NumFolio			INT(11), 			-- Numero de Folio a consultar

	Par_TipoChequera		CHAR(2),			-- Tipo de chequera E -estandar, P - Proforma
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de Consulta

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de constantes
	DECLARE Fecha_Vacia 			DATE;
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Entero_Cero				INT(1);
	DECLARE SalidaSI				CHAR(1);
	DECLARE EstatusA				CHAR(1);
	DECLARE Con_ChequeraSI			CHAR(1);
	DECLARE Con_UltimoFolio			INT(11);
	DECLARE Con_Folios				INT(11);
	DECLARE Con_FolioxBloqueCheques	INT(11);
	DECLARE SiExiste				CHAR(1);
	DECLARE NoExiste				CHAR(1);

	-- Asignacion de constantes
	SET Fecha_Vacia					:= '1900-01-01';
	SET Cadena_Vacia				:= '';
	SET Entero_Cero					:= 0;
	SET SalidaSI					:= 'S';
	SET EstatusA					:= 'A'; -- Estatus Asignado
	SET Con_ChequeraSI				:= 'S'; -- Si tiene Chequera
	SET Con_UltimoFolio				:= 2; 	-- Consulta para traer el ultimo folio utilizado
	SET Con_Folios					:= 3; 	-- Consulta que el folio no exista en otra chequera
	SET Con_FolioxBloqueCheques		:= 4; 	-- Consulta que el folio exista dentro de un bloque de cheques
	SET SiExiste					:= 'S';	-- Si existe el folio en alguna chequera
	SET NoExiste					:= 'N';	-- No existe el folio en alguna chequera

	-- No de consulta: 2
	-- Usado en: Ingreso de Operaciones para consultar el folio a utilizar
	IF(IFNULL(Par_NumCon,Entero_Cero)=Con_UltimoFolio) THEN
		SELECT MAX(CA.FolioUtilizar) AS FolioUtilizar,	MAX(CA.CuentaAhoID) AS CuentaAhoID,		MAX(CO.CueClave) AS CueClave,	MAX(CO.RutaCheque) AS RutaCheque
			FROM CAJASCHEQUERA AS CA
				INNER JOIN CUENTASAHOTESO AS CO
					ON CA.InstitucionID=CO.InstitucionID AND CA.NumCtaInstit=CO.NumCtaInstit
			WHERE CA.SucursalID			= Par_SucursalID
				AND CA.InstitucionID	= Par_InstitucionID
				AND CA.CajaID			= Par_CajaID
				AND CA.NumCtaInstit		= Par_NumCtaInstit
                AND CA.TipoChequera		= Par_TipoChequera
				AND CA.FolioUtilizar 	< CA.FolioCheqFinal
				LIMIT 1;
	END IF;

	-- No de consulta: 3
	-- Usado en: Asignacion de Chequeras a Suc. (GRID)
	IF(IFNULL(Par_NumCon,Entero_Cero)=Con_Folios AND IFNULL(Par_NumFolio,Entero_Cero)>Entero_Cero)THEN
		IF EXISTS(SELECT *
					FROM 	CAJASCHEQUERA CC INNER JOIN INSTITUCIONES IT ON CC.InstitucionID = IT.InstitucionID
							INNER JOIN CUENTASAHOTESO CA
							ON IT.InstitucionID = CA.InstitucionID AND CC.NumCtaInstit = CA.NumCtaInstit
							INNER JOIN SUCURSALES SU ON CC.SucursalID = SU.SucursalID
					WHERE   CC.Estatus		 = EstatusA
					AND 	CA.Chequera 	 = Con_ChequeraSI
					AND 	CA.Estatus		 = EstatusA
					AND 	(CC.InstitucionID = Par_InstitucionID
								AND CC.NumCtaInstit = Par_NumCtaInstit
								AND CC.TipoChequera = Par_TipoChequera)
					AND 	Par_NumFolio BETWEEN FolioCheqInicial AND FolioCheqFinal)THEN

			SELECT SiExiste AS ExistenciaFolio;
		ELSE
			SELECT NoExiste AS ExistenciaFolio;
		END IF;
	END IF;

	-- No de consulta: 4
	-- Usado en: Consulta folio en bloque de cheques por sucursal
	IF(IFNULL(Par_NumCon,Entero_Cero)=Con_FolioxBloqueCheques AND IFNULL(Par_NumFolio,Entero_Cero)>Entero_Cero)THEN
		IF EXISTS(SELECT *
			FROM CAJASCHEQUERA CC INNER JOIN INSTITUCIONES IT ON CC.InstitucionID = IT.InstitucionID
						INNER JOIN CUENTASAHOTESO CA
						ON IT.InstitucionID = CA.InstitucionID AND CC.NumCtaInstit = CA.NumCtaInstit
						INNER JOIN SUCURSALES SU ON CC.SucursalID = SU.SucursalID
				WHERE   CC.Estatus		 = EstatusA
					AND CA.Chequera 	 = Con_ChequeraSI
					AND CA.Estatus		 = EstatusA
					AND CC.SucursalID	 = Par_SucursalID
					AND CC.CajaID		 = Par_CajaID
					AND (CC.InstitucionID = Par_InstitucionID AND CC.NumCtaInstit = Par_NumCtaInstit AND CC.TipoChequera = Par_TipoChequera)
					AND (FolioCheqInicial<= Par_NumFolio AND Par_NumFolio <= FolioCheqFinal))THEN
			SELECT SiExiste AS ExistenciaFolio;
		ELSE
			SELECT NoExiste AS ExistenciaFolio;
		END IF;
	END IF;


END TerminaStore$$