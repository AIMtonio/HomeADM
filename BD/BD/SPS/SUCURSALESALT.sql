-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUCURSALESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUCURSALESALT`;
DELIMITER $$

CREATE PROCEDURE `SUCURSALESALT`(
/* =============== SP DE ALTA DE SUCURSALES ================ */
	Par_SucursalID		INT(11),		-- Numero de la Sucursal nueva (alta por no existencia)
	Par_NombreSucur		VARCHAR(50),	-- Nombre de la sucursal
	Par_TipoSucurs		VARCHAR(50),	-- Tipo de Sucursal C.- Corporativa A.- Atencion al cliente
	Par_PlazaID			INT(11),		-- ID de la Plaza donde la sucursal tiene Operaciones (PLAZAS)
	Par_CenCosID		INT(11),		-- ID del Centro de Costos (CENTROCOSTOS)

	Par_IVA				DECIMAL(12,2),	-- IVA de la Sucursal
	Par_TasaISR			DECIMAL(12,2),	-- Tasa ISR de la Sucursal
	Par_NomGerente		INT(11),		-- ID Gerente de la Sucursal (USUARIOS)
	Par_SubGerente		INT(11),		-- ID Subgerente de la Sucursal (USUARIOS)
	Par_EstadoID		INT(11),		-- ID del estado de la rep. (ESTADOSREPUB)

	Par_MunicipioID		INT(11),		-- ID del Municipio (MUNICIPIOSREPUB)
	Par_Calle			VARCHAR(100),	-- Nombre de la Calle
	Par_numero			CHAR(10),		-- Numero de la direccion
	Par_ColoniaID		INT(11),	-- Nombre de la Colonia
	Par_CP				CHAR(5),		-- Codigo Postal

	Par_Telefono		VARCHAR(20),	-- Telefono de la Sucural
	Par_DifHorMatr		INT(11),		-- Diferecia de horario en horas con respecto a la Matriz
	Par_FechaSucur		DATE,			-- Fecha de la Sucursal
	Par_DirCompl		VARCHAR(250),	-- Direccion completa de la sucursal
	Par_PoderNotarialGte VARCHAR(500),	-- Descripcion del Poder Notarial del Gerente

	Par_PoderNotarial	 CHAR(1),		-- S.- Si N.- No requiere de poder notarial
	Par_TituloGte		 VARCHAR(10),	-- Titulo del Gerente
	Par_TituloSubGte	 VARCHAR(10),	-- Titulo del SubGerente
	Par_ExtTelefonoPart	 VARCHAR(6),	-- Extension del telefono
	Par_PromotorCaptaID	 CHAR(45),		-- Numero de Promotor de Captacion asignado a una sucursal N.-No Asignado

    Par_ClaveSucCNBV	VARCHAR(8),		-- Clave de la Sucursal proporcionado por la CNBV para reportes pld
    Par_ClaveSucOpeCred	VARCHAR(10),	-- Clave de Sucursal que opera el credito - siti - regulatorios D0841 - C451
    Par_Latitud			VARCHAR(10),
    Par_Longitud        VARCHAR(11),
    Par_LocalidadID		INT,			-- Id de la localidad de la sucursal
	Par_HoraInicioOper TIME,        -- Horario de inicio de operacion de sucursal
	Par_HoraFinOper    TIME,        -- Horario de fin de operacion de sucursal

    Par_Salida          CHAR(1),		-- Indica el tipo de salida S.- SI N.- No
    INOUT Par_NumErr    INT,			-- Numero de Error
    INOUT Par_ErrMen    VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),

	Aud_NumTransaccion	BIGINT(20)
	)

TerminaStore: BEGIN

-- Declaracion de constantes
DECLARE	NumeroSucursal	INT;
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Estatus_Apert	CHAR(1);
DECLARE	SalidaSi		CHAR(1);
DECLARE	TipoSocap		INT(11);
DECLARE	TipoSofipo		INT(11);
DECLARE Var_ColoniaDes		VARCHAR(45);
-- Declaracion de Variables
DECLARE	Var_LocalidadID INT(11);
DECLARE Var_ColoniaID	INT(11);
DECLARE Var_InstitucionID	INT(11);
DECLARE Var_TipoInstitID	INT(11);
DECLARE Var_Consecutivo		INT(11);
DECLARE Var_Control			VARCHAR(20);
DECLARE	varUsuario 	INT;
DECLARE	varCentroC 	INT;
DECLARE	varPlaza 	INT;
DECLARE	varEstado 	INT;
DECLARE	varMuni 	INT;

-- Asignacion de constantes
SET	NumeroSucursal	:= 0;			-- Numero de Sucursal
SET	Cadena_Vacia	:= '';			-- Cadena vacia
SET	Fecha_Vacia		:= '1900-01-01';-- Fecha vacia
SET	Entero_Cero		:= 0;			-- Entero Cero
SET	Estatus_Apert	:= 'A';			-- Estatus Aperturada
SET	SalidaSi		:= 'S';			-- Salida SI
SET	TipoSocap		:= 6; 			-- Corresponde a TIPOSINSTITUCION: scap
SET	TipoSofipo		:= 3;			-- Corresponde a TIPOSINSTITUCION: sofipo

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SUCURSALESALT');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

	IF(IFNULL(Par_SucursalID, Entero_Cero)) <= Entero_Cero THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := CONCAT('Numero de Sucursal no Permitido.');
		SET Var_Control := 'sucursalID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EmpresaID, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 002;
		SET Par_ErrMen := CONCAT('La Empresa esta vacia.');
		SET Var_Control := 'empresaID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_NombreSucur, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 003;
		SET Par_ErrMen := CONCAT('El Nombre de la Sucursal esta vacio.');
		SET Var_Control := 'nombreSucurs' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoSucurs, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 004;
		SET Par_ErrMen := CONCAT('El Tipo de Sucursal esta vacio.');
		SET Var_Control := 'tipoSucursal' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_NomGerente, Entero_Cero)) <> Entero_Cero THEN
		SET varUsuario := (SELECT UsuarioID FROM USUARIOS WHERE UsuarioID = Par_NomGerente );
		IF(IFNULL(varUsuario, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 005;
			SET Par_ErrMen := CONCAT('El Gerente Indicado no Existe.');
			SET Var_Control := 'nombreGerente' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;


	IF(IFNULL(Par_SubGerente, Entero_Cero)) <> Entero_Cero THEN
		SET varUsuario := (SELECT UsuarioID FROM USUARIOS WHERE UsuarioID = Par_SubGerente );
		IF(IFNULL(varUsuario, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 006;
			SET Par_ErrMen := CONCAT('El SubGerente Indicado no Existe.');
			SET Var_Control := 'SubGerente' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_CenCosID, Entero_Cero)) <> Entero_Cero THEN
		SET varCentroC := (SELECT CentroCostoID FROM CENTROCOSTOS WHERE CentroCostoID = Par_CenCosID  ) ;
		IF(IFNULL(varCentroC, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 007;
			SET Par_ErrMen := CONCAT('El Centro de Costo Indicado no Existe.');
			SET Var_Control := 'centroCostoID' ;
			LEAVE ManejoErrores;
		END IF;

		IF EXISTS (SELECT CentroCostoID
					FROM SUCURSALES
						WHERE CentroCostoID = Par_CenCosID)THEN
			SET Par_NumErr	:= 008;
			SET Par_ErrMen	:= 'El Centro de Costo Indicado ya se encuentra asignado a otra sucursal.';
			SET Var_Control := 'centroCostoID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_PlazaID, Entero_Cero)) <> Entero_Cero THEN
		SET varPlaza := (SELECT PlazaID FROM PLAZAS WHERE PlazaID = Par_PlazaID);
		IF(IFNULL(varPlaza, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 009;
			SET Par_ErrMen := CONCAT('La Plaza Indicada no Existe.');
			SET Var_Control := 'plazaID' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_EstadoID, Entero_Cero)) <> Entero_Cero THEN
		SET varEstado:= (SELECT EstadoID FROM ESTADOSREPUB WHERE EstadoID= Par_EstadoID);
		IF(IFNULL(varEstado, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 010;
			SET Par_ErrMen := CONCAT('El Estado Indicado no Existe.');
			SET Var_Control := 'estadoID' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_MunicipioID, Entero_Cero)) <> Entero_Cero THEN
		SET varMuni:= (SELECT MunicipioID FROM MUNICIPIOSREPUB WHERE MunicipioID = Par_MunicipioID AND EstadoID = Par_EstadoID);
		IF(IFNULL(varMuni, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 011;
			SET Par_ErrMen := CONCAT('El Municipio Indicado no Existe.');
			SET Var_Control := 'municipioID' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;


	SELECT IFNULL(InstitucionID,Entero_Cero) INTO Var_InstitucionID
		FROM PARAMETROSSIS;

	SELECT IFNULL(TipoInstitID,Entero_Cero) INTO Var_TipoInstitID
		FROM INSTITUCIONES
			WHERE InstitucionID=Var_InstitucionID;

	IF(IFNULL(Par_Latitud, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 012;
			SET Par_ErrMen := CONCAT('La Latitud de la Sucursal esta vacia.');
			SET Var_Control := 'latitud' ;
			LEAVE ManejoErrores;
		END IF;

	    IF(IFNULL(Par_Longitud, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 013;
			SET Par_ErrMen := CONCAT('La Longitud de la Sucursal esta vacia.');
			SET Var_Control := 'longitud' ;
			LEAVE ManejoErrores;
		END IF;

	    IF(IFNULL(Par_ColoniaID, Entero_Cero)) <> Entero_Cero THEN
			SELECT SUBSTR(Asentamiento,1,45) AS Colonia INTO Var_ColoniaDes
				FROM COLONIASREPUB WHERE ColoniaID = Par_ColoniaID
				AND EstadoID = Par_EstadoID AND MunicipioID = Par_MunicipioID;
		END IF;

	    SET Var_ColoniaDes := IFNULL(Var_ColoniaDes,Cadena_Vacia);


	IF(Var_TipoInstitID=TipoSocap OR Var_TipoInstitID=TipoSofipo)THEN
		IF(IFNULL(Par_ClaveSucCNBV, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 014;
			SET Par_ErrMen := CONCAT('La Clave de la Sucursal de la CNBV esta vacia.');
			SET Var_Control := 'claveSucCNBV' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;

    IF(IFNULL(Par_ClaveSucOpeCred, Cadena_Vacia)) = Cadena_Vacia AND Var_TipoInstitID=TipoSofipo THEN
			SET Par_NumErr := 015;
			SET Par_ErrMen := CONCAT('La Clave de la Sucursal que opera el Credito esta vacia.');
			SET Var_Control := 'claveSucOpeCred' ;
			LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_LocalidadID, Entero_Cero)) <= Entero_Cero THEN
		SET Par_NumErr := 016;
		SET Par_ErrMen := CONCAT('La Localidad esta Vacia.');
		SET Var_Control := 'localidadID' ;
		LEAVE ManejoErrores;
	END IF;

	SET Aud_FechaActual := CURRENT_TIMESTAMP();
	IF (Par_PoderNotarial='N') THEN
		SET  Par_PoderNotarialGte :=Cadena_Vacia;
	END IF;

	IF(IFNULL(Par_HoraInicioOper, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 017;
		SET Par_ErrMen := CONCAT('Horario inicio de operaciones vacio');
		SET Var_Control := 'horaInicioOper' ;
	LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_HoraFinOper, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 018;
		SET Par_ErrMen := CONCAT('Horario fin de operaciones vacio');
		SET Var_Control := 'horaFinOper' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_HoraFinOper<=Par_HoraInicioOper) THEN
		SET Par_NumErr := 019;
		SET Par_ErrMen := CONCAT('Horario inicio de operacion es mayor al horario fin de operaciones ');
		SET Var_Control := 'horaInicioOper' ;
		LEAVE ManejoErrores;
	END IF;



	INSERT INTO SUCURSALES (
		SucursalID,			EmpresaID,			 NombreSucurs,		TipoSucursal,	FechaSucursal,
		EstadoID,			MunicipioID,		 CP,				ColoniaID,	Colonia,		Calle,
		Numero,				DirecCompleta,		 PlazaID,			IVA,			CentroCostoID,
		Telefono,			NombreGerente,		 SubGerente,		TasaISR,		DifHorarMatriz,
		Estatus,			PoderNotarialGte,    PoderNotarial,		TituloGte,		TituloSubGte,
		ExtTelefonoPart,	PromotorCaptaID,	 ClaveSucCNBV,		ClaveSucOpeCred,Usuario,
        Latitud,			Longitud,		     FechaActual,		LocalidadID,     HoraInicioOper,
        HoraFinOper,        DireccionIP,		    ProgramaID,			 Sucursal,			NumTransaccion)
	VALUES (
		Par_SucursalID,		Par_EmpresaID,		 Par_NombreSucur,	Par_TipoSucurs,	Par_FechaSucur,
		Par_EstadoID,		Par_MunicipioID,	 Par_CP,			Par_ColoniaID,	Var_ColoniaDes,	Par_Calle,
		Par_numero,			Par_DirCompl,		 Par_PlazaID,		Par_IVA,		Par_CenCosID,
		Par_Telefono,		Par_NomGerente,		 Par_SubGerente,	Par_TasaISR,	Par_DifHorMatr,
		Estatus_Apert,		Par_PoderNotarialGte,Par_PoderNotarial,	Par_TituloGte,	Par_TituloSubGte,
		Par_ExtTelefonoPart,Par_PromotorCaptaID, Par_ClaveSucCNBV,	Par_ClaveSucOpeCred,	Aud_Usuario,
        Par_Latitud,		Par_Longitud,		 Aud_FechaActual,	Par_LocalidadID,Par_HoraInicioOper,
        Par_HoraFinOper,     Aud_DireccionIP,	Aud_ProgramaID,		 Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr := 000;
		SET Par_ErrMen := CONCAT('Sucursal Agregada Exitosamente: ', CONVERT(Par_SucursalID, CHAR));
		SET Var_Control := 'sucursalID' ;

END ManejoErrores;

IF(Par_Salida = SalidaSi) THEN
    SELECT 	Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
            Par_SucursalID AS Consecutivo;
END IF;

END TerminaStore$$