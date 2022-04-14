
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCNBVOPEREELALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDCNBVOPEREELALT`;
DELIMITER $$
CREATE PROCEDURE `PLDCNBVOPEREELALT`(
	-- SP que se manda a llamar dentro del sp PLDHISREELEVANALT al momento de la generacion del archivo a enviar a la CNBV
	Par_EmpresaID			INT(11),		-- ID de la Empresa
	Par_PeriodoInicio		DATE,			-- Fecha de Inicio del Periodo
	Par_PeriodoFin			DATE,			-- Fecha Final del Periodo
	Par_Salida           	CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     	INT(11),		-- Numero de Error

	INOUT Par_ErrMen     	VARCHAR(400),	-- Mensaje de Error
    -- Parametros de Auditoria
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE	TipRep				INT(11);
DECLARE	FolRee				INT(11);
DECLARE	PerConver			CHAR(10);
DECLARE	OrgSup				VARCHAR(6);
DECLARE	ClaveCas			VARCHAR(6);
DECLARE	NacCte				CHAR(1);
DECLARE	Tiperson			CHAR(1);
DECLARE	Concat_Nom			VARCHAR(60);
DECLARE	RazonSoc			VARCHAR(60);
DECLARE CurpCte				VARCHAR(18);
DECLARE TelCte				VARCHAR(60);
DECLARE FecNac				DATE;
DECLARE	ActEco				VARCHAR(15);
DECLARE FecOpera			VARCHAR(12);
DECLARE	FeNacimien			VARCHAR(8);
DECLARE	ValNac				CHAR(1);

DECLARE	FolRee2				INT(11);
DECLARE	PerConver2			CHAR(10);
DECLARE	OrgSup2				VARCHAR(6);
DECLARE	ClaveCas2			VARCHAR(6);
DECLARE	DomConcat			VARCHAR(200);


-- variables para Cursor

DECLARE VarFecGe			DATE;
DECLARE VarPeriodo			INT(11);
DECLARE VarPerIni			DATE;
DECLARE VarPeriodoF			DATE;
DECLARE VarSuc				INT(11);
DECLARE VarFcha				DATE;
DECLARE VarLocSu			VARCHAR(10);
DECLARE VarTipOpe			VARCHAR(3);
DECLARE VarInsMon			VARCHAR(3);
DECLARE VarCte				INT(11);
DECLARE VarCuenAho			BIGINT(12);
DECLARE VarMto				DOUBLE;
DECLARE VarMonId			VARCHAR(3);
DECLARE VarPNom				VARCHAR(45);
DECLARE VarSNom				VARCHAR(45);
DECLARE VarTNom				VARCHAR(45);
DECLARE VarApP				VARCHAR(45);
DECLARE VarApM				VARCHAR(45);
DECLARE VarRfC				VARCHAR(13);
DECLARE VarRfCpM			VARCHAR(12);
DECLARE VarCall				VARCHAR(100);
DECLARE VarLocTe			VARCHAR(60);
DECLARE VarCpCte			VARCHAR(60);
DECLARE VarMpo				VARCHAR(60);
DECLARE VarEdo				VARCHAR(60);
DECLARE VarColCte			VARCHAR(200);
DECLARE VarClaveCNBV		CHAR(4);
DECLARE Var_LimpiaDirPLD	CHAR(1);
DECLARE Var_UsuarioServicioID	INT(11);			-- Identificador del Usuario de Servicio

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		VARCHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE	PersF				CHAR(1);
DECLARE	PersM				CHAR(1);
DECLARE	PM					CHAR(1);
DECLARE	Nal					CHAR(1);
DECLARE	Ext					CHAR(1);
DECLARE	Des					CHAR(1);
DECLARE Str_SI				CHAR(1);
DECLARE Str_NO				CHAR(1);
DECLARE EstatusVigente		CHAR(1);
DECLARE Error_Key       	INT;
DECLARE Error_SQLEXCEPTION	INT;
DECLARE Error_DUPLICATEKEY	INT;
DECLARE Error_VARUNQUOTED	INT;
DECLARE Error_INVALIDNULL	INT;

-- Declaracion de Cursor para el historico de op relevantes
DECLARE  CursorHisOpeReelevant  CURSOR FOR
	SELECT 	`FechaGeneracion`,		`PeriodoID`,			`PeriodoInicio`,			`PeriodoFin`,				`SucursalID`,
			`Fecha`,				`Localidad`,			`TipoOperacionID`,			`InstrumentMonID`,			`ClienteID`,
			`CuentaAhoID`,			`Monto`,				`ClaveMoneda`,				`PrimerNombreCliente`,		`SegundoNombreCliente`,
			`TercerNombreCliente`,	`ApellidoPatCliente`,	`ApellidoMatCliente`,		`RFC`,						`Calle`,
            `ColoniaCliente`,		`LocalidadCliente`,		`CP`,						`MunicipioID`,				`EstadoID`,
            `UsuarioServicioID`
	  FROM 	`PLDHIS-REELEVAN`
		WHERE PeriodoInicio >=Par_PeriodoInicio AND PeriodoFin<=Par_PeriodoFin
		ORDER BY Fecha;

-- Asignacion de Constantes
SET	TipRep					:= 1;					-- Tipo de Reporte de operaciones Reelevantes
SET Cadena_Vacia			:= '';					-- Cadena Vacia
SET Fecha_Vacia				:= '1900-01-01';		-- Fecha Vacia
SET Entero_Cero				:= 0;					-- Entero Cero
SET	PersF					:= '1';					-- PersonaFisica
SET	PersM					:= '2';					-- Persona Moral
SET	Nal						:= '1';					-- Nacional
SET	Ext						:= '2';					-- Extranjera
SET	Des						:= '0';					-- No es Persona Nacional ni Extranjera
SET	Str_SI					:= 'S';					-- Constante SI
SET	Str_NO					:= 'N';					-- Constante NO
SET	EstatusVigente			:= 'V';					-- Estatus Vigente
SET Error_SQLEXCEPTION		:= 1;					-- Codigo de Error para el SQLSTATE: SQLEXCEPTION.
SET Error_DUPLICATEKEY		:= 2; 					-- Codigo de Error para el SQLSTATE: LLAVE DUPLICADA, COLUMNA NO DEBE SER NULA, COLUMNA AMBIGUA, ETC.
SET Error_VARUNQUOTED		:= 3; 					-- Codigo de Error para el SQLSTATE: VARIABLE SIN COMILLAS, FUNCIONES DE AGREGACION (GROUP BY, SUM, ETC), ETC.
SET Error_INVALIDNULL		:= 4; 					-- Codigo de Error para el SQLSTATE: USO INVALIDO DEL VALOR NULL, ERROR OBTENIDO DESDE EXPRESON REGULAR.

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDCNBVOPEREELALT');
		END;


	TRUNCATE TMPPLDCNBVOPREL;

	IF(NOT EXISTS(SELECT FolioID
					FROM PARAMETROSPLD
						WHERE Estatus = EstatusVigente))THEN
		SET Par_NumErr = 001;
		SET Par_ErrMen = CONCAT('No Existen Parametros Vigentes para Organos Supervisores.');
		LEAVE ManejoErrores;
	END IF;

	SET PerConver2			:= (DATE_FORMAT(Par_PeriodoFin,'%Y%m'));
	SET FolRee2				:= 1;
	SET OrgSup2				:= (SELECT ClaveOrgSupervisor FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);
	SET ClaveCas2			:= (SELECT ClaveEntCasfim FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);
	SET Var_LimpiaDirPLD	:= LEFT(FNPARAMGENERALES('LimpiaDirPLD'),1);
	SET Var_LimpiaDirPLD	:= IFNULL(Var_LimpiaDirPLD,Str_NO);

	OPEN  CursorHisOpeReelevant;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLOHIST:LOOP
				FETCH CursorHisOpeReelevant  INTO
					VarFecGe,		VarPeriodo,		VarPerIni,		VarPeriodoF,		VarSuc,
					VarFcha,		VarLocSu,		VarTipOpe,		VarInsMon,			VarCte,
					VarCuenAho,		VarMto,			VarMonId,		VarPNom,			VarSNom,
					VarTNom,		VarApP,			VarApM,			VarRfC,				VarCall,
                    VarColCte,		VarLocTe,		VarCpCte,		VarMpo,				VarEdo,
                    Var_UsuarioServicioID;

				START TRANSACTION;
				BEGIN

					DECLARE EXIT HANDLER FOR SQLEXCEPTION 		SET Error_Key := Error_SQLEXCEPTION;
					DECLARE EXIT HANDLER FOR SQLSTATE '23000'	SET Error_Key := Error_DUPLICATEKEY;
					DECLARE EXIT HANDLER FOR SQLSTATE '42000'	SET Error_Key := Error_VARUNQUOTED;
					DECLARE EXIT HANDLER FOR SQLSTATE '22004'	SET Error_Key := Error_INVALIDNULL;

					-- Inicalizacion
					SET Error_Key   	:= Entero_Cero;

					SET VarSuc		:=IFNULL(VarSuc,Entero_Cero);
					SET VarFcha		:=IFNULL(VarFcha, Fecha_Vacia);
					SET VarTipOpe	:=IFNULL(VarTipOpe, Cadena_Vacia);
					SET	VarInsMon	:=IFNULL(VarInsMon, Cadena_Vacia);
					SET VarCte		:=IFNULL(VarCte,Entero_Cero);
					SET VarCuenAho	:=IFNULL(VarCuenAho, Entero_Cero);
					SET VarMto		:=IFNULL(VarMto, Entero_Cero);
					SET VarMonId	:=IFNULL(VarMonId, Cadena_Vacia);
					SET VarRfC		:=IFNULL(VarRfC, Cadena_Vacia);

					SET	VarPNom 	:= IFNULL(VarPNom,Cadena_Vacia);
					SET VarSNom		:= IFNULL(VarSNom,Cadena_Vacia);
					SET	VarTNom		:= IFNULL(VarTNom,Cadena_Vacia);
					SET VarApP		:= IFNULL(VarApP,Cadena_Vacia);
					SET VarApM  	:= IFNULL(VarApM,Cadena_Vacia);

					SET VarLocSu	:=IFNULL(VarLocSu,Cadena_Vacia );
					SET VarCall		:=IFNULL(VarCall, Cadena_Vacia);
					SET VarLocTe	:=IFNULL(VarLocTe,Cadena_Vacia );
					SET VarCpCte	:=IFNULL(VarCpCte, Cadena_Vacia);
					SET VarMpo		:=IFNULL(VarMpo,Cadena_Vacia );
					SET VarEdo		:=IFNULL(VarEdo, Cadena_Vacia );
					SET Var_UsuarioServicioID	:=IFNULL(Var_UsuarioServicioID,Entero_Cero);

                    -- INICIO SI ES UN CLIENTE
                    IF(VarCte > Entero_Cero)THEN
						SET VarColCte	:=(SELECT FNGENDIRECCION(4,EstadoID,MunicipioID, LocalidadID, ColoniaID,
																Calle,NumeroCasa,NumInterior,Piso,PrimeraEntreCalle,
																SegundaEntreCalle,CP,Descripcion,Lote,Manzana)
											FROM DIRECCLIENTE
											WHERE ClienteID=VarCte AND Oficial=Str_SI LIMIT 1);
						SET VarColCte	:= IF(Var_LimpiaDirPLD = Str_SI, FNLIMPIACARACTERESGEN(VarColCte, 'MA'), VarColCte);

						SET DomConcat	:=(SELECT FNGENDIRECCION(3,EstadoID,MunicipioID, LocalidadID, ColoniaID,
																Calle,NumeroCasa,NumInterior,Piso,PrimeraEntreCalle,
																SegundaEntreCalle,CP,Descripcion,Lote,Manzana)
											FROM DIRECCLIENTE
											WHERE ClienteID=VarCte AND Oficial=Str_SI LIMIT 1);
						SET DomConcat	:= IF(Var_LimpiaDirPLD = Str_SI, FNLIMPIACARACTERESGEN(DomConcat, 'MA'), DomConcat);

                        SET NacCte		:= (SELECT C.Nacion FROM CLIENTES C WHERE C.ClienteID = VarCte);
						SET NacCte		:= IFNULL(NacCte,Cadena_Vacia );

						SET Tiperson	:= (SELECT C.TipoPersona FROM CLIENTES C WHERE C.ClienteID = VarCte);
						SET Tiperson	:= IFNULL(Tiperson, Cadena_Vacia);

						SET RazonSoc	:= (SELECT C.RazonSocial FROM CLIENTES C WHERE C.ClienteID = VarCte);
						SET RazonSoc	:= IFNULL(RazonSoc,Cadena_Vacia );

						SET CurpCte		:= (SELECT C.CURP FROM CLIENTES C WHERE C.ClienteID = VarCte);
						SET CurpCte		:= IFNULL(CurpCte, Cadena_Vacia);

						SET VarRfC		:= (SELECT C.RFCOficial FROM CLIENTES C WHERE C.ClienteID = VarCte);
						SET VarRfC		:= IFNULL(VarRfC, Cadena_Vacia);

						SET TelCte		:= (SELECT C.Telefono FROM CLIENTES C WHERE C.ClienteID = VarCte);
						SET TelCte		:= IFNULL(TelCte, Cadena_Vacia);

						SET FecNac		:= (SELECT C.FechaNacimiento FROM CLIENTES C WHERE C.ClienteID = VarCte);
						SET FecNac		:= IFNULL(FecNac,Fecha_Vacia );

						SET ActEco 		:= (SELECT AB.ActividadBMXID FROM CLIENTES C
											INNER JOIN ACTIVIDADESBMX AB ON C.ActividadBancoMx=AB.ActividadBMXID
											WHERE C.ClienteID = VarCte);

						SET ActEco			:=	IFNULL(ActEco,Cadena_Vacia);

						SET VarClaveCNBV := (SELECT IFNULL(Pai.ClaveCNBV,Cadena_Vacia)
											FROM PAISES Pai,
												 CLIENTES Cli
											WHERE Cli.LugarNacimiento = Pai.PaisID
												AND Cli.ClienteID = VarCte);

						SET VarClaveCNBV	:=  IFNULL(VarClaveCNBV, Cadena_Vacia);
					END IF;
					-- FIN SI ES UN CLIENTE

					-- INICIO SI ES UN USUARIO DE SERVICIO
                    IF(Var_UsuarioServicioID > Entero_Cero)THEN
						SET VarColCte	:=(SELECT FNGENDIRECCION(4,EstadoID,MunicipioID, LocalidadID, ColoniaID,
																Calle,NumExterior,NumInterior,Piso,Cadena_Vacia,
																Cadena_Vacia,CP,Cadena_Vacia,Lote,Manzana)
											FROM USUARIOSERVICIO
											WHERE UsuarioServicioID = Var_UsuarioServicioID);
						SET VarColCte	:= IF(Var_LimpiaDirPLD = Str_SI, FNLIMPIACARACTERESGEN(VarColCte, 'MA'), VarColCte);

						SET DomConcat	:=(SELECT FNGENDIRECCION(3,EstadoID,MunicipioID, LocalidadID, ColoniaID,
																Calle,NumExterior,NumInterior,Piso,Cadena_Vacia,
																Cadena_Vacia,CP,Cadena_Vacia,Lote,Manzana)
											FROM USUARIOSERVICIO
											WHERE UsuarioServicioID = Var_UsuarioServicioID);
						SET DomConcat	:= IF(Var_LimpiaDirPLD = Str_SI, FNLIMPIACARACTERESGEN(DomConcat, 'MA'), DomConcat);

						SET NacCte		:= (SELECT Nacionalidad FROM USUARIOSERVICIO WHERE UsuarioServicioID = Var_UsuarioServicioID);
						SET NacCte		:= IFNULL(NacCte,Cadena_Vacia );

						SET Tiperson	:= (SELECT TipoPersona FROM USUARIOSERVICIO WHERE UsuarioServicioID = Var_UsuarioServicioID);
						SET Tiperson	:= IFNULL(Tiperson, Cadena_Vacia);

						SET RazonSoc	:= (SELECT RazonSocial FROM USUARIOSERVICIO WHERE UsuarioServicioID = Var_UsuarioServicioID);
						SET RazonSoc	:= IFNULL(RazonSoc,Cadena_Vacia );

						SET CurpCte		:= (SELECT CURP FROM USUARIOSERVICIO WHERE UsuarioServicioID = Var_UsuarioServicioID);
						SET CurpCte		:= IFNULL(CurpCte, Cadena_Vacia);

						SET VarRfC		:= (SELECT RFCOficial FROM USUARIOSERVICIO WHERE UsuarioServicioID = Var_UsuarioServicioID);
						SET VarRfC		:= IFNULL(VarRfC, Cadena_Vacia);

						SET TelCte		:= (SELECT Telefono FROM USUARIOSERVICIO WHERE UsuarioServicioID = Var_UsuarioServicioID);
						SET TelCte		:= IFNULL(TelCte, Cadena_Vacia);

						SET FecNac		:= (SELECT FechaNacimiento FROM USUARIOSERVICIO WHERE UsuarioServicioID = Var_UsuarioServicioID);
						SET FecNac		:= IFNULL(FecNac,Fecha_Vacia);

						SET ActEco			:=	Cadena_Vacia;
						SET VarClaveCNBV	:=  Cadena_Vacia;

					END IF;
					-- FIN SI ES UN USUARIO DE SERVICIO

					SET Concat_Nom	:= Cadena_Vacia;
					SET Concat_Nom	:= LEFT(FNLIMPIACARACTERESGEN(FNGENNOMBRECOMPLETO(VarPNom,VarSNom,VarTNom,Cadena_Vacia,Cadena_Vacia),'MA'),60);
					SET VarApP		:= LEFT(FNLIMPIACARACTERESGEN(VarApP,'MA'),45);
					SET VarApM		:= LEFT(FNLIMPIACARACTERESGEN(VarApM,'MA'),45);
					SET PerConver	:= (DATE_FORMAT(Par_PeriodoFin,'%Y%m'));

					SET FolRee		:= (SELECT IFNULL(MAX(Folio),Entero_Cero) + 1 FROM TMPPLDCNBVOPREL);
					SET OrgSup		:= (SELECT ClaveOrgSupervisor FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);
					SET ClaveCas	:= (SELECT ClaveEntCasfim FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);

					IF(NacCte='N')THEN
						SET 	ValNac := Nal;
					END IF;

					IF(NacCte='E')THEN
						SET 	ValNac := Ext;
					END IF;

					IF(NacCte<> 'N' AND NacCte<>'E')THEN
						SET 	ValNac := Des;
					END IF;

					IF(Tiperson ='F' OR Tiperson='A')THEN
						SET PM := PersF;
					ELSE
						SET PM := PersM;
					END IF;

					SET FecOpera 	:= DATE_FORMAT(VarFcha,'%Y%m%d');

					SET	FeNacimien	:=  DATE_FORMAT(FecNac,'%Y%m%d');

					INSERT INTO TMPPLDCNBVOPREL(
						`TipoReporte`,		`PeriodoReporte`,		`Folio`,				`ClaveOrgSupervisor`,		`ClaveEntCasFim`,
						`LocalidadSuc`,		`SucursalID`,			`TipoOperacionID`,		`InstrumentMonID`,			`CuentaAhoID`,
						`Monto`,			`ClaveMoneda`,			`FechaOpe`,				`FechaDeteccion`,			`Nacionalidad`,
						`TipoPersona`,		`RazonSocial`,			`Nombre`,				`ApellidoPat`,				`ApellidoMat`,
						`RFC`,				`CURP`,					`FechaNac`,				`Domicilio`,				`Colonia`,
						`Localidad`,		`Telefono`,				`ActEconomica`,			`NomApoderado`,				`ApPatApoderado`,
						`ApMatApoderado`,	`RFCApoderado`,			`CURPApoderado`,		`CtaRelacionadoID`,			`CuenAhoRelacionado`,
						`ClaveSujeto`,		`NomTitular`,			`ApPatTitular`,			`ApMatTitular`,				`DesOperacion`,
						`Razones`,			`ClaveCNBV`,			`ClienteID`,			`UsuarioServicioID`,		`EmpresaID`,
                        `Usuario`,			`FechaActual`,			`DireccionIP`,			`ProgramaID`,				`Sucursal`,
                        `NumTransaccion`)
					VALUES(
						TipRep,				PerConver,				FolRee,					OrgSup,						ClaveCas,
						VarLocSu,			VarSuc,					VarTipOpe,				VarInsMon,					VarCuenAho,
						VarMto,				VarMonId,				FecOpera,				Cadena_Vacia,				ValNac,
						PM,		IFNULL(RazonSoc,Cadena_Vacia),		Concat_Nom,				VarApP,						VarApM,
						VarRfC,				CurpCte,				FeNacimien,				DomConcat,					VarColCte,
						VarLocTe,			TelCte,					ActEco,					Cadena_Vacia,				Cadena_Vacia,
						Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,				Cadena_Vacia,
						Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,				Cadena_Vacia,
						Cadena_Vacia,		VarClaveCNBV,			VarCte,					Var_UsuarioServicioID,		Par_EmpresaID,
                        Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID, 			Aud_Sucursal,
                        Aud_NumTransaccion);

					-- Si es exito toda la transaccion dentro del cursor, se hace COMMIT
					IF(Error_Key = 0)THEN
						SET Par_NumErr = 000;
						SET Par_ErrMen = CONCAT('Datos Guardados Exitosamente.');
						COMMIT;
					END IF;

					-- Si durante la transaccion dentro del cursor hay algun error, se hace ROLLBACK
					IF(	Error_Key = Error_SQLEXCEPTION	OR Error_Key = Error_DUPLICATEKEY OR
						Error_Key = Error_VARUNQUOTED	OR Error_Key = Error_INVALIDNULL)THEN
						SET Par_NumErr = 001;
						SET Par_ErrMen = CONCAT('Error al guardar los datos.');
						ROLLBACK;
					END IF;
				END; -- END START TRANSACTION
		END LOOP CICLOHIST;
	END;
	CLOSE CursorHisOpeReelevant;

	IF(Error_Key != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;


	INSERT INTO PLDCNBVOPEREELE(
			TipoReporte,		PeriodoReporte,			Folio,				ClaveOrgSupervisor,			ClaveEntCasFim,
			LocalidadSuc,		SucursalID,				TipoOperacionID,	InstrumentMonID,			CuentaAhoID,
			Monto,				ClaveMoneda,			FechaOpe,			FechaDeteccion,				Nacionalidad,
			TipoPersona,		RazonSocial,			Nombre,				ApellidoPat,				ApellidoMat,
			RFC,				CURP,FechaNac,			Domicilio,			Colonia,					Localidad,
			Telefono,			ActEconomica,			NomApoderado,		ApPatApoderado,				ApMatApoderado,
			RFCApoderado,		CURPApoderado,			CtaRelacionadoID,	CuenAhoRelacionado,			ClaveSujeto,
			NomTitular,			ApPatTitular,			ApMatTitular,		DesOperacion,				Razones,
			ClaveCNBV,			ClienteID,				UsuarioServicioID,	EmpresaID,					Usuario,
			FechaActual,		DireccionIP,			ProgramaID,			Sucursal,					NumTransaccion)
		SELECT
			TipoReporte,		PeriodoReporte,			Folio,				ClaveOrgSupervisor,			ClaveEntCasFim,
			LocalidadSuc,		SucursalID,				TipoOperacionID,	InstrumentMonID,			CuentaAhoID,
			Monto,				ClaveMoneda,			FechaOpe,			FechaDeteccion,				Nacionalidad,
			TipoPersona,		RazonSocial,			Nombre,				ApellidoPat,				ApellidoMat,
			RFC,				CURP,FechaNac,			Domicilio,			Colonia,					Localidad,
			Telefono,			ActEconomica,			NomApoderado,		ApPatApoderado,				ApMatApoderado,
			RFCApoderado,		CURPApoderado,			CtaRelacionadoID,	CuenAhoRelacionado,			ClaveSujeto,
			NomTitular,			ApPatTitular,			ApMatTitular,		DesOperacion,				Razones,
			ClaveCNBV,			ClienteID,				UsuarioServicioID,	EmpresaID,					Usuario,
			FechaActual,		DireccionIP,			ProgramaID,			Sucursal,					NumTransaccion
			FROM TMPPLDCNBVOPREL;

	SET Par_NumErr := 000;
	SET Par_ErrMen := CONCAT('Datos Guardados Exitosamente.');

END ManejoErrores;

IF(Par_Salida = Str_SI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            'controlCNBV' AS control,
			Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$

