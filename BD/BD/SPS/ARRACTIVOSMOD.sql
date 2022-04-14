-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRACTIVOSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRACTIVOSMOD`;DELIMITER $$

CREATE PROCEDURE `ARRACTIVOSMOD`(
# =====================================================================================
# -- STORED PROCEDURE PARA MODIFICAR ACTIVOS.
# =====================================================================================
	Par_ActivoID            INT(11),            -- Parametro que corresponde al ID del activo
	Par_Descripcion         VARCHAR(150),       -- Parametro que corresponde al Nombre del Activo
	Par_TipoActivo          INT(11),            -- Parametro que corresponde al Tipo de Activo:1=Autos, 2=Muebles
	Par_SubtipoActivoID     INT(11),            -- Parametro que corresponde al Id de la categoria a la que pertenece el Activo, llave primaria
	Par_Modelo              VARCHAR(50),        -- Parametro que corresponde al Modelo del Activo
	Par_MarcaID             INT(11),            -- Parametro que corresponde al ID del catalogo de marcas, llave primaria de la tabla: ARRMARCAACTIVO

	Par_NumeroSerie         VARCHAR(45),        -- Parametro que corresponde al Numero de serie del activo
	Par_NumeroFactura       VARCHAR(10),        -- Parametro que corresponde al Numero o folio de la factura del activo
	Par_ValorFactura        DECIMAL(14,2),      -- Parametro que corresponde al Valor de la factura del activo
	Par_CostosAdicionales   DECIMAL(14,2),      -- Parametro que corresponde al Costos adicionales que pudiera tener el activo
	Par_FechaAdquisicion    DATE,               -- Parametro que corresponde a la Fecha en la que se adquirio o compro el activo
	Par_VidaUtil            INT(11),            -- Parametro que corresponde a la vida util del activo en meses

	Par_PorcentDepreFis     DECIMAL(5,2),       -- Parametro que corresponde al Porcentaje de depreciacion fiscal
	Par_PorcentDepreAjus    DECIMAL(5,2),       -- Parametro que corresponde al Porcentaje de depreciacion ajustada
	Par_PlazoMaximo         INT(11),            -- Parametro que corresponde al Plazo maximo
	Par_PorcentResidMax     DECIMAL(5,2),       -- Parametro que corresponde al Porcentaje residual maximo
	Par_Estatus             CHAR(1),            -- Parametro que corresponde al Estatus de activos:A=Activo, B=Baja, L=Ligado o asociado

	Par_EstadoID            INT(11),            -- Parametro que corresponde al ID del estado, llave primaria de la tabla: ESTADOSREPUB
	Par_MunicipioID         INT(11),            -- Parametro que corresponde al ID del municipio, llave primaria de la tabla: MUNICIPIOSREPUB
	Par_LocalidadID         INT(11),            -- Parametro que corresponde al ID de la localidad, llave primaria de la tabla: LOCALIDADREPUB
	Par_ColoniaID           INT(11),            -- Parametro que corresponde al ID de la colonia, llave primaria de la tabla: COLONIASREPUB
	Par_Calle               VARCHAR(50),        -- Parametro que corresponde a la Calle del domicilio

	Par_NumeroCasa          CHAR(10),           -- Parametro que corresponde al Numero del domicilio
	Par_NumeroInterior      CHAR(10),           -- Parametro que corresponde al Numero interior del domicilio
	Par_Piso                CHAR(50),           -- Parametro que corresponde al Piso
	Par_PrimerEntrecalle    VARCHAR(50),        -- Parametro que corresponde al Primer crusamiento del domicilio
	Par_SegundaEntreCalle   VARCHAR(50),        -- Parametro que corresponde al Segundo crusamiento del domicilio

	Par_CP                  CHAR(5),            -- Parametro que corresponde al Codigo Postal
	Par_Latitud             VARCHAR(45),        -- Parametro que corresponde a la  Latitud
	Par_Longitud            VARCHAR(45),        -- Parametro que corresponde a la Longitud
	Par_Lote                VARCHAR(50),        -- Parametro que corresponde al lote
	Par_Manzana             VARCHAR(50),        -- Parametro que corresponde a la Manzana
	Par_DescripcionDom      VARCHAR(200),       -- Parametro que corresponde a la Descripcion del domicilio

	Par_AseguradoraID       INT(11),            -- Parametro que corresponde al ID de la aseguradora, llave primaria de la tabla: ARRASEGURADORA'
	Par_EstaAsegurado       CHAR(1),            -- Parametro que indica si el activo esta asgurado o no: S=Si, N=No
	Par_NumPolizaSeguro     VARCHAR(20),        -- Parametro que corresponde al Numero de poliza
	Par_FechaAdquiSeguro    DATE,               -- Parametro que corresponde a la Fecha en la que se adquirio el seguro
	Par_InicioCoberSeguro   DATE,               -- Parametro que corresponde a la Fecha en la que inica la cobertura del seguro

	Par_FinCoberSeguro      DATE,               -- Parametro que corresponde a la Fecha en la que finaliza la cobertura del seguro
	Par_SumaAseguradora     DECIMAL(14,2),      -- Parametro que corresponde al Monto total de la suma del seguro
	Par_ValorDeduciSeguro   DECIMAL(14,2),      -- Parametro que corresponde al Deducible del seguro
	Par_Observaciones       VARCHAR(200),       -- Parametro que corresponde a los Comentarios u observaciones

	Par_Salida				CHAR(1),			-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr		INT(11),			-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro que corresponde a un mensaje de exito o error

	Par_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal			INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(100);	-- Variable de control
	DECLARE Var_DirecCompleta       VARCHAR(500);   -- Dreccion completa del domicilio
	DECLARE Var_NombreEstado        VARCHAR(100);   -- Nombre del estado obtenido de la tabla: ESTADOSREPUB
	DECLARE Var_NombreMunicipio     VARCHAR(150);   -- Nombre del municipio obtenida de la tabla: MUNICIPIOSREPUB
	DECLARE Var_NombreColonia       VARCHAR(200);   -- Nombre de la colonia obtenida de la tabla: COLONIASREPUB

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;			-- Fecha Vacia
	DECLARE	Entero_Cero				INT(11);		-- Entero cero
	DECLARE Salida_Si				CHAR(1);		-- Indica que si se devuelve un mensaje de salida
	DECLARE Salida_No				CHAR(1);		-- Indica que no se devuelve un mensaje de salida
	DECLARE Decimal_Cero			DECIMAL(14,2);	-- Decimal 0

	DECLARE Par_AseguradoSi			CHAR(1);		-- Indica que el activo esta asegurado.
	DECLARE Est_Activo			    CHAR(1);		-- Indica el estatus esta activo A=activo
	DECLARE Est_Inactivo			CHAR(1);		-- Indica el estatus esta inactivo I=inactivo
	DECLARE	Par_AsegDefault			INT(11);		-- Aseguradora por default cuando no especificada una aseguradora para el activo.

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';				-- Valor de cadena vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Valor de fecha vacia.
	SET	Entero_Cero				:= 0;				-- Valor de entero cero.
	SET Salida_Si				:= 'S';      		-- Si se devuelve una salida Si
	SET Salida_No				:= 'N';      		-- NO se devuelve una salida No
	SET	Decimal_Cero			:= 0.0;				-- Valor de decimal cero.

	SET Par_AseguradoSi			:= 'S';      		-- Si esta asegurado el activo S = si
	SET Est_Activo			    := 'A';      		-- Estatus Activo=A
	SET Est_Inactivo			:= 'I';      		-- Estatus Inactivo=I
	SET Par_AsegDefault			:= 1;      			-- Aseguradora por default.

	-- Valores por default si son nulos
	SET Var_Control			    := IFNULL(Var_Control,Cadena_Vacia);

    SET Par_ActivoID		    := IFNULL(Par_ActivoID,Entero_Cero);
    SET Par_Descripcion		    := IFNULL(Par_Descripcion,Cadena_Vacia);
	SET Par_TipoActivo		    := IFNULL(Par_TipoActivo,Entero_Cero);
	SET Par_SubtipoActivoID	    := IFNULL(Par_SubtipoActivoID,Entero_Cero);
	SET Par_Modelo	            := IFNULL(Par_Modelo,Cadena_Vacia);
	SET Par_MarcaID             := IFNULL(Par_MarcaID,Entero_Cero);

	SET Par_NumeroSerie	        := IFNULL(Par_NumeroSerie,Cadena_Vacia);
	SET Par_NumeroFactura	    := IFNULL(Par_NumeroFactura,Cadena_Vacia);
	SET Par_ValorFactura		:= IFNULL(Par_ValorFactura,Decimal_Cero);
	SET Par_CostosAdicionales	:= IFNULL(Par_CostosAdicionales,Decimal_Cero);
	SET Par_FechaAdquisicion    := IFNULL(Par_FechaAdquisicion,Fecha_Vacia);
	SET Par_VidaUtil		    := IFNULL(Par_VidaUtil,Entero_Cero);

	SET Par_PorcentDepreFis     := IFNULL(Par_PorcentDepreFis,Decimal_Cero);
	SET Par_PorcentDepreAjus	:= IFNULL(Par_PorcentDepreAjus,Decimal_Cero);
	SET Par_PlazoMaximo			:= IFNULL(Par_PlazoMaximo,Entero_Cero);
	SET Par_PorcentResidMax		:= IFNULL(Par_PorcentResidMax,Decimal_Cero);
	SET Par_Estatus             := IFNULL(Par_Estatus,Cadena_Vacia);

	SET Par_EstadoID			:= IFNULL(Par_EstadoID,Entero_Cero);
	SET Par_MunicipioID			:= IFNULL(Par_MunicipioID,Entero_Cero);
	SET Par_LocalidadID			:= IFNULL(Par_LocalidadID,Entero_Cero);
	SET Par_ColoniaID			:= IFNULL(Par_ColoniaID,Entero_Cero);
	SET Par_Calle			    := IFNULL(Par_Calle,Cadena_Vacia);

	SET Par_NumeroCasa			:= IFNULL(Par_NumeroCasa,Cadena_Vacia);
	SET Par_NumeroInterior		:= IFNULL(Par_NumeroInterior,Cadena_Vacia);
	SET Par_Piso                := IFNULL(Par_Piso,Cadena_Vacia);
	SET Par_PrimerEntrecalle    := IFNULL(Par_PrimerEntrecalle,Cadena_Vacia);
	SET Par_SegundaEntreCalle   := IFNULL(Par_SegundaEntreCalle,Cadena_Vacia);

	SET Par_CP                  := IFNULL(Par_CP,Cadena_Vacia);
	SET Par_Latitud             := IFNULL(Par_Latitud,Cadena_Vacia);
	SET Par_Longitud            := IFNULL(Par_Longitud,Cadena_Vacia);
	SET Par_Lote                := IFNULL(Par_Lote,Cadena_Vacia);
	SET Par_Manzana             := IFNULL(Par_Manzana,Cadena_Vacia);
	SET Par_DescripcionDom      := IFNULL(Par_DescripcionDom,Cadena_Vacia);

	SET Par_AseguradoraID		:= IFNULL(Par_AseguradoraID,Entero_Cero);
	SET Par_EstaAsegurado       := IFNULL(Par_EstaAsegurado,Cadena_Vacia);
	SET Par_NumPolizaSeguro     := IFNULL(Par_NumPolizaSeguro,Cadena_Vacia);
	SET Par_FechaAdquiSeguro	:= IFNULL(Par_FechaAdquiSeguro,Fecha_Vacia);
	SET Par_InicioCoberSeguro	:= IFNULL(Par_InicioCoberSeguro,Fecha_Vacia);

	SET Par_FinCoberSeguro		:= IFNULL(Par_FinCoberSeguro,Fecha_Vacia);
	SET Par_SumaAseguradora		:= IFNULL(Par_SumaAseguradora,Decimal_Cero);
	SET Par_ValorDeduciSeguro	:= IFNULL(Par_ValorDeduciSeguro,Decimal_Cero);
	SET Par_Observaciones       := IFNULL(Par_Observaciones,Cadena_Vacia);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. REF: SP-ARRACTIVOSMOD');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		-- validaciones
		IF(Par_ActivoID = Entero_Cero) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'El ID del activo esta vacio.';
			SET Var_Control		:= 'activoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Descripcion = Cadena_Vacia) THEN
			SET Par_NumErr		:= 002;
			SET Par_ErrMen		:= 'El nombre del activo esta vacio.';
			SET Var_Control		:= 'descripcion';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoActivo = Entero_Cero) THEN
			SET Par_NumErr		:= 003;
			SET Par_ErrMen		:= 'El tipo de activo esta vacio.';
			SET Var_Control		:= 'tipoActivo';
			LEAVE ManejoErrores;
		END IF;

		IF (NOT EXISTS (SELECT SubtipoActivoID
							FROM ARRCSUBTIPOACTIVO
							WHERE   SubtipoActivoID = Par_SubtipoActivoID)) THEN
			SET Par_NumErr		:= 004;
			SET Par_ErrMen		:= 'El tipo de activo no es valido.';
			SET Var_Control		:= 'subtipoActivoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Modelo = Cadena_Vacia) THEN
			SET Par_NumErr		:= 005;
			SET Par_ErrMen		:= 'El modelo del activo esta vacio.';
			SET Var_Control		:= 'modelo';
			LEAVE ManejoErrores;
		END IF;


		IF (NOT EXISTS (SELECT MarcaID
							FROM ARRMARCAACTIVO
							WHERE   MarcaID = Par_MarcaID)) THEN
			SET Par_NumErr		:= 006;
			SET Par_ErrMen		:= 'La marca no es valida.';
			SET Var_Control		:= 'marcaID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NumeroSerie = Cadena_Vacia) THEN
			SET Par_NumErr		:= 007;
			SET Par_ErrMen		:= 'El numero de serie esta vacio.';
			SET Var_Control		:= 'numeroSerie';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NumeroFactura = Cadena_Vacia) THEN
			SET Par_NumErr		:= 008;
			SET Par_ErrMen		:= 'El numero de factura esta vacio.';
			SET Var_Control		:= 'numeroFactura';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ValorFactura = Decimal_Cero) THEN
			SET Par_NumErr		:= 009;
			SET Par_ErrMen		:= 'El valor factura esta vacio.';
			SET Var_Control		:= 'valorFactura';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_FechaAdquisicion = Fecha_Vacia) THEN
			SET Par_NumErr		:= 010;
			SET Par_ErrMen		:= 'La fecha esta vacia.';
			SET Var_Control		:= 'fechaAdquisicion';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_VidaUtil = Entero_Cero) THEN
			SET Par_NumErr		:= 011;
			SET Par_ErrMen		:= 'La vida util del activo esta vacia.';
			SET Var_Control		:= 'vidaUtil';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_PlazoMaximo = Entero_Cero) THEN
			SET Par_NumErr		:= 012;
			SET Par_ErrMen		:= 'El plazo maximo esta vacio.';
			SET Var_Control		:= 'plazoMaximo';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Estatus = Cadena_Vacia) THEN
			SET Par_NumErr		:= 013;
			SET Par_ErrMen		:= 'El estatus esta vacio.';
			SET Var_Control		:= 'estatus';
			LEAVE ManejoErrores;
		END IF;

		-- validaciones del domicilio
		SELECT Nombre
          INTO Var_NombreEstado
            FROM ESTADOSREPUB
            WHERE  EstadoID = Par_EstadoID;
        SET Var_NombreEstado := IFNULL(Var_NombreEstado,Cadena_Vacia);

		IF (Var_NombreEstado = Cadena_Vacia) THEN
			SET Par_NumErr		:= 014;
			SET Par_ErrMen		:= 'El estado no es valido.';
			SET Var_Control		:= 'estadoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT Nombre
          INTO Var_NombreMunicipio
            FROM MUNICIPIOSREPUB
            WHERE  MunicipioID = Par_MunicipioID
              AND  EstadoID = Par_EstadoID;
         SET Var_NombreMunicipio := IFNULL(Var_NombreMunicipio,Cadena_Vacia);

		IF (Var_NombreMunicipio = Cadena_Vacia) THEN
			SET Par_NumErr		:= 015;
			SET Par_ErrMen		:= 'El municipio no es valido.';
			SET Var_Control		:= 'municipioID';
			LEAVE ManejoErrores;
		END IF;

		IF (NOT EXISTS (SELECT LocalidadID
							FROM LOCALIDADREPUB
							WHERE  LocalidadID = Par_LocalidadID
							  AND  MunicipioID = Par_MunicipioID
							  AND  EstadoID = Par_EstadoID)) THEN
			SET Par_NumErr		:= 016;
			SET Par_ErrMen		:= 'La localidad no es valida.';
			SET Var_Control		:= 'localidadID';
			LEAVE ManejoErrores;
		END IF;

		SELECT Asentamiento
			INTO Var_NombreColonia
			FROM COLONIASREPUB
			WHERE  ColoniaID = Par_ColoniaID
			  AND  MunicipioID = Par_MunicipioID
			  AND  EstadoID = Par_EstadoID;
        SET Var_NombreColonia := IFNULL(Var_NombreColonia,Cadena_Vacia);

		IF (Var_NombreColonia = Cadena_Vacia) THEN
			SET Par_NumErr		:= 017;
			SET Par_ErrMen		:= 'La colonia no es valida.';
			SET Var_Control		:= 'coloniaID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Calle = Cadena_Vacia) THEN
			SET Par_NumErr		:= 018;
			SET Par_ErrMen		:= 'El numero de la calle esta vacio.';
			SET Var_Control		:= 'calle';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NumeroCasa = Cadena_Vacia) THEN
			SET Par_NumErr		:= 019;
			SET Par_ErrMen		:= 'El numero del domicilio esta vacio.';
			SET Var_Control		:= 'numeroCasa';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CP = Cadena_Vacia) THEN
			SET Par_NumErr		:= 020;
			SET Par_ErrMen		:= 'El Codigo Postal esta vacio.';
			SET Var_Control		:= 'cp';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_DescripcionDom = Cadena_Vacia) THEN
			SET Par_NumErr		:= 021;
			SET Par_ErrMen		:= 'La descripcion del domicilio esta vacio.';
			SET Var_Control		:= 'descripcionDom';
			LEAVE ManejoErrores;
		END IF;

		-- validaciones aseguradora
		IF(Par_EstaAsegurado = Cadena_Vacia) THEN
			SET Par_NumErr		:= 022;
			SET Par_ErrMen		:= 'La opcion esta asegurado esta vacia.';
			SET Var_Control		:= 'estaAsegurado';
			LEAVE ManejoErrores;
		END IF;

		-- validaciones obligatorias si esta asegurado el activo
		IF(Par_EstaAsegurado = Par_AseguradoSi) THEN
			IF (NOT EXISTS (SELECT AseguradoraID
							FROM ARRASEGURADORA
							WHERE  AseguradoraID = Par_AseguradoraID)) THEN
				SET Par_NumErr		:= 024;
				SET Par_ErrMen		:= 'La aseguradora no es valida.';
				SET Var_Control		:= 'aseguradoraID';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_NumPolizaSeguro = Cadena_Vacia) THEN
				SET Par_NumErr		:= 025;
				SET Par_ErrMen		:= 'El numero de poliza esta vacio.';
				SET Var_Control		:= 'numPolizaSeguro';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_FechaAdquiSeguro = Fecha_Vacia) THEN
				SET Par_NumErr		:= 026;
				SET Par_ErrMen		:= 'La Fecha de adquisicion del seguro esta vacia.';
				SET Var_Control		:= 'fechaAdquiSeguro';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_InicioCoberSeguro = Fecha_Vacia OR Par_InicioCoberSeguro < Par_FechaAdquiSeguro) THEN
				SET Par_NumErr		:= 027;
				SET Par_ErrMen		:= 'La fecha de inicio de la cobertura no es valida.';
				SET Var_Control		:= 'inicioCoberSeguro';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_FinCoberSeguro = Fecha_Vacia OR Par_FinCoberSeguro < Par_InicioCoberSeguro) THEN
				SET Par_NumErr		:= 028;
				SET Par_ErrMen		:= 'La fecha de fin de la cobertura no es valida.';
				SET Var_Control		:= 'finCoberSeguro';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_SumaAseguradora = Decimal_Cero) THEN
				SET Par_NumErr		:= 029;
				SET Par_ErrMen		:= 'La suma asegurada esta vacia.';
				SET Var_Control		:= 'sumaAseguradora';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ValorDeduciSeguro = Decimal_Cero) THEN
				SET Par_NumErr		:= 030;
				SET Par_ErrMen		:= 'El valor del deducible del seguro esta vacio.';
				SET Var_Control		:= 'valorDeduciSeguro';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_Observaciones = Cadena_Vacia) THEN
				SET Par_NumErr		:= 031;
				SET Par_ErrMen		:= 'Las observaciones estan vacias.';
				SET Var_Control		:= 'observaciones';
				LEAVE ManejoErrores;
			END IF;
		ELSE
            SET Par_AseguradoraID   := Par_AsegDefault;
		END IF;
		--  fin de validaciones

		-- Se actualiza unicamente si el activo tiene estatus A= Activo e I= Inactivo.
		IF (EXISTS(SELECT ActivoID
					FROM ARRACTIVOS
					WHERE ActivoID = Par_ActivoID
					  AND Estatus IN (Est_Activo,Est_Inactivo)))THEN
			-- formar la direccion completa
			SET Var_DirecCompleta := CONCAT(Par_Calle,', No. ',Par_NumeroCasa);

			IF(Par_NumeroInterior != Cadena_Vacia) THEN
				SET Var_DirecCompleta := CONCAT(Var_DirecCompleta,", INTERIOR ",Par_NumeroInterior);
			END IF;

			IF(Par_Piso != Cadena_Vacia) THEN
				SET Var_DirecCompleta := CONCAT(Var_DirecCompleta,", PISO ",Par_Piso);
			END IF;

			IF(Par_Lote != Cadena_Vacia) THEN
				SET Var_DirecCompleta := CONCAT(Var_DirecCompleta,", LOTE ",Par_Lote);
			END IF;

			IF(Par_Manzana != Cadena_Vacia) THEN
				SET Var_DirecCompleta := CONCAT(Var_DirecCompleta,", MANZANA ",Par_Manzana);
			END IF;

			SET Var_DirecCompleta := UPPER(CONCAT(Var_DirecCompleta,", COL. ",Var_NombreColonia,", C.P ",Par_CP,", ",Var_NombreMunicipio,", ",Var_NombreEstado,"."));


		-- Update de los campos en la tabla: ARRACTIVOS
			UPDATE ARRACTIVOS SET
				Descripcion         = Par_Descripcion,
				TipoActivo          = Par_TipoActivo,
				SubtipoActivoID     = Par_SubtipoActivoID,
				Modelo              = Par_Modelo,
				MarcaID             = Par_MarcaID,
				NumeroSerie         = Par_NumeroSerie,
				NumeroFactura       = Par_NumeroFactura,
				ValorFactura        = Par_ValorFactura,
				CostosAdicionales   = Par_CostosAdicionales,
				FechaAdquisicion    = Par_FechaAdquisicion,
				VidaUtil            = Par_VidaUtil,
				PorcentDepreFis     = Par_PorcentDepreFis,
				PorcentDepreAjus    = Par_PorcentDepreAjus,
				PlazoMaximo         = Par_PlazoMaximo,
				PorcentResidMax     = Par_PorcentResidMax,
				Estatus             = Par_Estatus,
				EstadoID            = Par_EstadoID,
				MunicipioID         = Par_MunicipioID,
				LocalidadID         = Par_LocalidadID,
				ColoniaID           = Par_ColoniaID,
				Calle               = Par_Calle,
				NumeroCasa          = Par_NumeroCasa,
				NumeroInterior      = Par_NumeroInterior,
				Piso                = Par_Piso,
				PrimerEntrecalle    = Par_PrimerEntrecalle,
				SegundaEntreCalle   = Par_SegundaEntreCalle,
				CP                  = Par_CP,
				Latitud             = Par_Latitud,
				Longitud            = Par_Longitud ,
				Lote                = Par_Lote,
				Manzana             = Par_Manzana,
				DescripcionDom      = Par_DescripcionDom,
				AseguradoraID       = Par_AseguradoraID,
				EstaAsegurado       = Par_EstaAsegurado,
				NumPolizaSeguro     = Par_NumPolizaSeguro,
				FechaAdquiSeguro    = Par_FechaAdquiSeguro,
				InicioCoberSeguro   = Par_InicioCoberSeguro,
				FinCoberSeguro      = Par_FinCoberSeguro,
				SumaAseguradora     = Par_SumaAseguradora,
				ValorDeduciSeguro   = Par_ValorDeduciSeguro,
				Observaciones       = Par_Observaciones,
				DireccionCompleta   = Var_DirecCompleta,

				EmpresaID           = Par_EmpresaID,
				Usuario             = Aud_Usuario,
				FechaActual         = Aud_FechaActual,
				DireccionIP         = Aud_DireccionIP,
				ProgramaID          = Aud_ProgramaID,
				Sucursal            = Aud_Sucursal,
				NumTransaccion      = Aud_NumTransaccion
				WHERE ActivoID = Par_ActivoID
					AND Estatus IN (Est_Activo,Est_Inactivo);

			SET Par_NumErr      := 000;
			SET Par_ErrMen      := CONCAT('Modificacion realizada exitosamente.');
			SET Var_Control     := 'tipoActivo';
		ELSE
				SET Par_NumErr      := 042;
				SET Par_ErrMen      := CONCAT('Activo no valido: ',Par_ActivoID);
				SET Var_Control     := 'activoID';

		END IF;
	END ManejoErrores;
	-- Si Par_Salida = S (SI)
	IF (Par_Salida = Salida_Si) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control;
	END IF;

	-- Fin del SP
END TerminaStore$$