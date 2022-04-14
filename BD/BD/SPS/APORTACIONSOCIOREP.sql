-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTACIONSOCIOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTACIONSOCIOREP`;DELIMITER $$

CREATE PROCEDURE `APORTACIONSOCIOREP`(

    Par_ClienteID       INT(11),
    Par_NumCon          TINYINT UNSIGNED,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
		)
TerminaStore: BEGIN


DECLARE Var_TotAporta           DECIMAL(16,2);
DECLARE Var_TotalAportacion     DECIMAL(16,2);
DECLARE Var_TotalDevolucion     DECIMAL(16,2);
DECLARE Var_Aportacion          CHAR(1);
DECLARE Var_Devolucion          CHAR(1);
DECLARE Var_PlazaID             INT(11);
DECLARE Var_PlazaNom            VARCHAR(50);
DECLARE Var_SucursalID          INT(11);
DECLARE Var_NomSucursal         VARCHAR(50);
DECLARE Var_ClienteDir          VARCHAR(200);
DECLARE MontoLetra              VARCHAR(200);
DECLARE Var_FechaSis			DATE;
DECLARE Var_PresidenteConsejo   VARCHAR(45);
DECLARE Var_ClienteID		    INT(11);
DECLARE Var_NombreSocio			VARCHAR(45);
DECLARE Var_CURP				CHAR(18);
DECLARE Var_EstSuc 				VARCHAR(45);
DECLARE Var_MunSuc				VARCHAR(45);
DECLARE Var_SucOrigen           INT(5);
DECLARE Var_NomSucOrigen        VARCHAR(45);
DECLARE Var_ConsecAportSocio    INT(11);
DECLARE MontoLetraMinus         VARCHAR(200);


DECLARE Cadena_Vacia			CHAR(1);
DECLARE Fecha_Vacia				DATE;
DECLARE Entero_Cero				INT;
DECLARE Con_Principal			INT;
DECLARE Dir_Oficial				CHAR(1);
DECLARE Seccion_Benefi			INT;
DECLARE Cue_Activa				CHAR(1);
DECLARE Es_Beneficiario			CHAR(1);
DECLARE Var_Principal			CHAR(1);
DECLARE Var_DescFecha			VARCHAR(200);
DECLARE Estatus_Vigente			CHAR(1);


DECLARE Var_EscrituraPublic		VARCHAR(50);
DECLARE Var_NomNotario			VARCHAR(100);
DECLARE Var_Notaria				INT(11);
DECLARE Var_ClienteInstitucion	INT(11);
DECLARE Var_NomLocRP			VARCHAR(150);
DECLARE Var_FolioRegPub			VARCHAR(10);
DECLARE Var_FechaRegPub			DATE;
DECLARE Var_TxtNotaria			VARCHAR(200);
DECLARE Var_TxtFecha			VARCHAR(200);
DECLARE EsConstitutiva			CHAR(1);


SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Con_Principal       := 1;
SET Seccion_Benefi      := 2;
SET Var_Aportacion      := 'A';
SET Var_Devolucion      := 'D';
SET Dir_Oficial         := 'S';
SET Es_Beneficiario     := 'S';
SET Cue_Activa          := 'A';
SET Var_Principal       := 'S';
SET Estatus_Vigente		:= 'V';
SET EsConstitutiva      := 'C';
SET Var_TxtNotaria 		:= '';
SET Var_TxtFecha 		:= '';

IF(Par_NumCon = Con_Principal) THEN

    SET Var_ClienteInstitucion	:= (SELECT ClienteInstitucion FROM PARAMETROSSIS WHERE	EmpresaID	= Par_EmpresaID);
    SET Var_ClienteInstitucion	:= IFNULL(Var_ClienteInstitucion, Entero_Cero);


    SELECT		ESC.EscrituraPublic, ESC.NomNotario, ESC.Notaria, MPIOSESC.Nombre as NomLocRP,	ESC.FolioRegPub,
				ESC.FechaRegPub
		INTO	Var_EscrituraPublic, Var_NomNotario, Var_Notaria, Var_NomLocRP,					Var_FolioRegPub,
				Var_FechaRegPub
    FROM	ESCRITURAPUB AS ESC
        INNER JOIN MUNICIPIOSREPUB AS MPIOSESC ON 	MPIOSESC.MunicipioID = ESC.LocalidadRegPub
												AND MPIOSESC.EstadoID = ESC.EstadoIDReg
    WHERE	ESC.ClienteID	= Var_ClienteInstitucion
		AND	ESC.Esc_Tipo	= EsConstitutiva
	LIMIT 1;

    SET Var_EscrituraPublic := IFNULL(Var_EscrituraPublic, Cadena_Vacia);
    SET Var_NomNotario		:= IFNULL(Var_NomNotario, Cadena_Vacia);
    SET Var_Notaria			:= IFNULL(Var_Notaria, Entero_Cero);
    SET Var_NomLocRP		:= IFNULL(Var_NomLocRP, Cadena_Vacia);
    SET Var_FolioRegPub		:= IFNULL(Var_FolioRegPub, Cadena_Vacia);
    SET Var_FechaRegPub		:= IFNULL(Var_FechaRegPub, Fecha_Vacia);
    SET Var_TxtNotaria		:= Var_EscrituraPublic;
    SET Var_TxtFecha		:= FNFECHATEXTO(Var_FechaRegPub);


	SELECT  CONCAT(
				IFNULL(PrimerNombre,Cadena_Vacia),
				(CASE WHEN IFNULL(SegundoNombre, Cadena_Vacia) != Cadena_Vacia
							THEN CONCAT(' ', IFNULL(SegundoNombre,Cadena_Vacia))
							ELSE Cadena_Vacia END),
				(CASE WHEN IFNULL(TercerNombre, Cadena_Vacia) != Cadena_Vacia
							THEN  CONCAT(' ', IFNULL(TercerNombre,Cadena_Vacia))
							ELSE Cadena_Vacia END), ' ',
				IFNULL(ApellidoPaterno,Cadena_Vacia), ' ', IFNULL(ApellidoMaterno,Cadena_Vacia)),
				CURP,		SucursalOrigen,	suc.NombreSucurs
		INTO	Var_NombreSocio,	Var_CURP,	Var_SucOrigen,	Var_NomSucOrigen
	FROM			CLIENTES AS  cli
	 	INNER JOIN	SUCURSALES AS suc	ON cli.SucursalOrigen = suc.SucursalID
	WHERE ClienteID = Par_ClienteID;

	SELECT		mun.Nombre,	est.Nombre
		INTO	Var_EstSuc,	Var_MunSuc
		FROM SUCURSALES AS Suc
      LEFT JOIN MUNICIPIOSREPUB AS mun ON Suc.MunicipioID	= mun.MunicipioID
	  LEFT JOIN ESTADOSREPUB	AS est ON mun.EstadoID		= est.EstadoID
	WHERE	Suc.SucursalID = Aud_Sucursal
		AND mun.MunicipioID = Suc.MunicipioID
		AND est.EstadoID	= Suc.EstadoID;


	SELECT AportaSocio, Saldo INTO Var_ConsecAportSocio, Var_TotalAportacion
		FROM APORTACIONSOCIO
		WHERE ClienteID = Par_ClienteID;


	SET Var_TotalAportacion := IFNULL(Var_TotalAportacion,Entero_Cero);
	SET Var_TotAporta := Var_TotalAportacion;

	SELECT Pz.PlazaID,Pz.Nombre,Suc.SucursalID,Suc.NombreSucurs
		INTO Var_PlazaID,Var_PlazaNom,Var_SucursalID,Var_NomSucursal
	FROM			SUCURSALES	AS Suc
		INNER JOIN	PLAZAS		AS Pz	ON Suc.PlazaID = Pz.PlazaID
	WHERE Suc.SucursalID = Aud_Sucursal;

	SELECT DireccionCompleta INTO Var_ClienteDir
		FROM DIRECCLIENTE
	WHERE ClienteID = Par_ClienteID
	AND  Oficial = Dir_Oficial;

	SELECT FechaSistema, PresidenteConsejo INTO Var_FechaSis, Var_PresidenteConsejo
		FROM PARAMETROSSIS;

	SELECT CONCAT(CASE
			WHEN WEEKDAY(Var_FechaSis)=0 THEN 'Lunes '
			ELSE CASE WHEN WEEKDAY(Var_FechaSis)=1 THEN 'Martes '
			ELSE CASE WHEN WEEKDAY(Var_FechaSis)=2 THEN 'Miercoles '
			ELSE CASE WHEN WEEKDAY(Var_FechaSis)=3 THEN 'Jueves '
			ELSE CASE WHEN WEEKDAY(Var_FechaSis)=4 THEN 'Viernes '
			ELSE CASE WHEN WEEKDAY(Var_FechaSis)=5 THEN 'Sabado '
			ELSE CASE WHEN WEEKDAY(Var_FechaSis)=6 THEN 'Domingo '
			END END END END END END END ,FUNCIONLETRASFECHA(Var_FechaSis)) INTO Var_DescFecha;


	SET MontoLetra		:= FUNCIONNUMLETRAS(Var_TotAporta);
	SET MontoLetraMinus := LOWER(FUNCIONNUMLETRAS(Var_TotAporta));



	upDATE APORTACIONSOCIO SET
		FechaCertificado	= Var_FechaSis
	WHERE  ClienteID	= Par_ClienteID ;


	SELECT	FORMAT(round(Var_TotAporta,2),2) AS TotMonto,	MontoLetra,			Var_PlazaID,			Var_PlazaNom,			Var_SucursalID,
			Var_NomSucursal,								Var_ClienteDir,		Var_DescFecha, 			Var_PresidenteConsejo,	Var_NombreSocio,
			Var_CURP, 										Var_SucOrigen,		Var_NomSucOrigen,		Var_EstSuc, 			Var_MunSuc,
			Var_ConsecAportSocio, 							MontoLetraMinus,	Var_EscrituraPublic,	Var_NomNotario, 		Var_Notaria,
			Var_NomLocRP, 									Var_FolioRegPub,	Var_TxtNotaria,			Var_TxtFecha;

END if;


IF(Par_NumCon = Seccion_Benefi) THEN
	SELECT Per.CuentaAhoID as Cuenta, Per.NombreCompleto, Tip.Descripcion as Relacion, ROUND(Per.Porcentaje,4) as Porcentaje,
			   Per.FechaNac, Per.TelefonoCasa, Per.TelefonoCelular,Per.Domicilio,Tip.Descripcion
			FROM CUENTASAHO Cue,
				 CUENTASPERSONA Per,
				 TIPORELACIONES Tip
			WHERE Cue.ClienteID = Par_ClienteID
			  and Cue.Estatus = Cue_Activa
			  and Cue.EsPrincipal = Var_Principal
			  and Cue.CuentaAhoID = Per.CuentaAhoID
			  and Per.EstatusRelacion = Estatus_Vigente
			  and Per.EsBeneficiario = Es_Beneficiario
			  and Per.ParentescoID = Tip.TipoRelacionID;
END IF;

END TerminaStore$$