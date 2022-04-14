-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GARANTIASAGROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `GARANTIASAGROALT`;

DELIMITER $$
CREATE PROCEDURE `GARANTIASAGROALT`(

	/* SP PARA EL ALTA DE GARANTIAS */
	Par_GarantiaID      	INT(11),		-- Numero de la garantia
	Par_ProspectoID	  	 	BIGINT(20),		-- Numero del prospecto
	Par_ClienteID	        INT(11),		-- Numero del cliete
	Par_AvalID	            INT(11),		-- Numero del aval
	Par_GaranteID	        INT(11),		-- ID del garante

	Par_GaranteNombre		VARCHAR(100),	-- Nombre del garante
	Par_TipoGarantiaID		INT(11),		-- Tipo de garantia
	Par_ClasifGarantiaID	INT(11), 		-- Clasificacion de la garantia
	Par_ValorComercial		DECIMAL(14,2), 	-- Valor comercial de la garantia
	Par_Observaciones	  	VARCHAR(1200),  -- Observaciones

	Par_EstadoID	        INT(11),		-- Clave de estado
	Par_MunicipioID	   		INT(11), 		-- Clave del municipio
	Par_Calle	            VARCHAR(100),   -- Nombre de la calle
	Par_Numero	            VARCHAR(10), 	-- Numero
	Par_NumeroInt	        VARCHAR(10), 	-- numero interior

	Par_Lote	            VARCHAR(10), 	-- Numero de lote
	Par_Manzana	            VARCHAR(100), 	-- Numero de manzana
	Par_Colonia	            VARCHAR(100), 	-- Codigo de colonia
	Par_CodigoPostal	    VARCHAR(10), 	-- Codigo postal
	Par_M2Construccion		DECIMAL(12,2),  -- Numero de metros de construccion

	Par_M2Terreno	        DECIMAL(12,2),	-- Metros del terreno
	Par_Asegurado	        CHAR(1), 		-- Tipo de asegurado
	Par_VencimientoPoliza	DATE , 			-- Vencimiento de la poliza
	Par_FechaValuacion	    DATE , 			-- Fecha de valuacion
	Par_NumAvaluo	        VARCHAR(10),	-- Numero de avaluo

	Par_NombreValuador		VARCHAR(100),	-- Nombre del valuador
	Par_Verificada	        CHAR(1), 		-- La garantia es verificada
	Par_FechaVerificacion	DATE , 			-- fecha de la verificacion
	Par_TipoGravemen	    CHAR(2), 		-- Tipo de gravamen
	Par_TipoInsCaptacion	CHAR(1), 		-- Tipo de Captacion

	Par_InsCaptacionID	    INT(11), 		-- Instrumento de captacion
	Par_MontoAsignado	    DECIMAL(14,2), 	-- Monto asignado
	Par_Estatus 	   		CHAR(1),		-- Estatus
	Par_NoIdentificacion    VARCHAR(50),	-- Numero de identificacion
	Par_TipoDocumentoID		INT(11), 		-- Tipo de documento presentado

	Par_Asegurador			VARCHAR(45),	-- Nombre del asegurador
	Par_NombreAutoridad		VARCHAR(45),	-- nombre de la autoridad
	Par_CargoAutoridad		VARCHAR(45),	-- Cargo de la autoridad
	Par_FechaCompFactura	DATE ,			-- fecha de compra de factura
	Par_FechaGrevemen		DATE ,			-- Fecha de gravamen

	Par_FolioRegistro		VARCHAR(45), 	-- Folio de registro
	Par_MontoGravemen		DECIMAL(14,2),	-- Monto de gravamen
	Par_NombBenefiGravem	VARCHAR(75), 	-- Nombre del beneficiario
	Par_NotarioID			INT(11),		-- ID de la notaria
	Par_NumPoliza			BIGINT(12), 		-- Numero de poliza

	Par_ReferenFactura		VARCHAR(45), 	-- Referencia de la factuara
	Par_RFCEmisor			VARCHAR(45),	-- RFC del emision
	Par_SerieFactura		VARCHAR(45), 	-- numero de serie factura o documento
	Par_ValorFactura		VARCHAR(45), 	-- Valor de la factura
	Par_FechaRegistro		DATE,			-- Fecha de registro

	Par_CalleGarante		VARCHAR(70),		-- Direccion de garante
	Par_NumIntGarante		VARCHAR(45),	-- Numero interior
	Par_NumExtGarante		VARCHAR(45), 	-- Numero exterior
	Par_ColoniaGarante		VARCHAR(65),	-- colonia
	Par_CodPostalGarante	VARCHAR(45), 	-- codigo postal

	Par_EstadoIDGarante		INT(11),		-- Estado del garante
	Par_MunicipioGarante	INT(11), 			-- fin direccion de garante

	Par_LocalidadID			INT(11), 			-- Id de la localidad
	Par_ColoniaID			INT(11), 			-- Id de la colonia
	Par_MontoAvaluo     	DECIMAL(21,2),		-- Monto de Valuacion de la garantia
	Par_Proporcion			DECIMAL (14,2),
	Par_Usufructuaria		CHAR (1),

	Par_Salida 				CHAR(1),
	INOUT	Par_NumErr	 	INT,
	INOUT	Par_ErrMen	 	VARCHAR(400),
	INOUT	Var_FolioSalida	INT,

	Aud_EmpresaID	    	INT(11),			-- Parametros de auditoria --
	Aud_Usuario	       		INT(11),			-- Parametros de auditoria --
	Aud_FechaActual			DATETIME ,			-- Parametros de auditoria --
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de auditoria --
	Aud_ProgramaID	    	VARCHAR(70),		-- Parametros de auditoria --
	Aud_Sucursal	    	INT(11),			-- Parametros de auditoria --
	Aud_NumTransaccion		BIGINT(20) 			-- Parametros de auditoria --

		)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control		VARCHAR(50);	-- Variable de control
	DECLARE Var_Consecutivo	VARCHAR(20);	-- Numero consecutivo de registro

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);		-- Constantes Entero Cero
	DECLARE Cadena_Vacia	CHAR(1);		-- Constantes Cadena Vacia
	DECLARE Con_NO			CHAR(1);		-- Constantes NO
	DECLARE Salida_SI		CHAR(1);		-- Constantes Salida SI
	DECLARE FechaVacia		DATE;			-- Constantes Fecha Vacia

	-- Asignacion de constantes
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET Salida_SI			:= 'S';
	SET Con_NO				:= 'N';
	SET FechaVacia			:= '1900-01-01';
	SET Var_Consecutivo		:= Entero_Cero;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
									concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-GARANTIASAGROALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		SET Par_GarantiaID			:= IFNULL(Par_GarantiaID, Entero_Cero);
		SET Par_ProspectoID			:= IFNULL(Par_ProspectoID, Entero_Cero);
		SET Par_ClienteID			:= IFNULL(Par_ClienteID, Entero_Cero);
		SET Par_AvalID				:= IFNULL(Par_AvalID, Entero_Cero);
		SET Par_GaranteID			:= IFNULL(Par_GaranteID, Entero_Cero);

		SET Par_GaranteNombre		:= IFNULL(Par_GaranteNombre, Cadena_Vacia);
		SET Par_TipoGarantiaID		:= IFNULL(Par_TipoGarantiaID, Entero_Cero);
		SET Par_ClasifGarantiaID	:= IFNULL(Par_ClasifGarantiaID, Entero_Cero);
		SET Par_ValorComercial		:= IFNULL(Par_ValorComercial, Entero_Cero);
		SET Par_Observaciones		:= IFNULL(Par_Observaciones, Cadena_Vacia);

		SET Par_EstadoID			:= IFNULL(Par_EstadoID, Entero_Cero);
		SET Par_MunicipioID			:= IFNULL(Par_MunicipioID, Entero_Cero);
		SET Par_Calle				:= IFNULL(Par_Calle, Cadena_Vacia);
		SET Par_Numero				:= IFNULL(Par_Numero, Cadena_Vacia);
		SET Par_NumeroInt			:= IFNULL(Par_NumeroInt, Cadena_Vacia);

		SET Par_Lote				:= IFNULL(Par_Lote, Cadena_Vacia);
		SET Par_Manzana				:= IFNULL(Par_Manzana, Cadena_Vacia);
		SET Par_Colonia				:= IFNULL(Par_Colonia, Cadena_Vacia);
		SET Par_CodigoPostal		:= IFNULL(Par_CodigoPostal, Cadena_Vacia);
		SET Par_M2Construccion		:= IFNULL(Par_M2Construccion, Entero_Cero);

		SET Par_M2Terreno			:= IFNULL(Par_M2Terreno, Entero_Cero);
		SET Par_Asegurado			:= IFNULL(Par_Asegurado, Cadena_Vacia);
		SET Par_VencimientoPoliza	:= IFNULL(Par_VencimientoPoliza, FechaVacia);
		SET Par_FechaValuacion		:= IFNULL(Par_FechaValuacion, FechaVacia);
		SET Par_NumAvaluo			:= IFNULL(Par_NumAvaluo, Cadena_Vacia);

		SET Par_NombreValuador		:= IFNULL(Par_NombreValuador, Cadena_Vacia);
		SET Par_Verificada			:= IFNULL(Par_Verificada, Cadena_Vacia);
		SET Par_FechaVerificacion	:= IFNULL(Par_FechaVerificacion, FechaVacia);
		SET Par_TipoGravemen		:= IFNULL(Par_TipoGravemen, Cadena_Vacia);
		SET Par_TipoInsCaptacion	:= IFNULL(Par_TipoInsCaptacion, Cadena_Vacia);

		SET Par_InsCaptacionID		:= IFNULL(Par_InsCaptacionID, Entero_Cero);
		SET Par_MontoAsignado		:= IFNULL(Par_MontoAsignado, Entero_Cero);
		SET Par_Estatus 			:= IFNULL(Par_Estatus, Cadena_Vacia);
		SET Par_NoIdentificacion	:= IFNULL(Par_NoIdentificacion, Cadena_Vacia);
		SET Par_TipoDocumentoID		:= IFNULL(Par_TipoDocumentoID,  Entero_Cero);

		SET Par_Asegurador			:= IFNULL(Par_Asegurador, Cadena_Vacia);
		SET Par_NombreAutoridad		:= IFNULL(Par_NombreAutoridad, Cadena_Vacia);
		SET Par_CargoAutoridad		:= IFNULL(Par_CargoAutoridad, Cadena_Vacia);
		SET Par_FechaCompFactura	:= IFNULL(Par_FechaCompFactura, FechaVacia);
		SET Par_FechaGrevemen		:= IFNULL(Par_FechaGrevemen, FechaVacia);

		SET Par_FolioRegistro		:= IFNULL(Par_FolioRegistro, Cadena_Vacia);
		SET Par_MontoGravemen		:= IFNULL(Par_MontoGravemen, Entero_Cero);
		SET Par_NombBenefiGravem	:= IFNULL(Par_NombBenefiGravem, Cadena_Vacia);
		SET Par_NotarioID			:= IFNULL(Par_NotarioID, Entero_Cero);
		SET Par_NumPoliza			:= IFNULL(Par_NumPoliza, Entero_Cero);

		SET Par_ReferenFactura		:= IFNULL(Par_ReferenFactura, Cadena_Vacia);
		SET Par_RFCEmisor			:= IFNULL(Par_RFCEmisor, Cadena_Vacia);
		SET Par_SerieFactura		:= IFNULL(Par_SerieFactura, Cadena_Vacia);
		SET Par_ValorFactura		:= IFNULL(Par_ValorFactura, Cadena_Vacia);
		SET Par_FechaRegistro		:= IFNULL(Par_FechaRegistro, FechaVacia);

		SET Par_CalleGarante		:= IFNULL(Par_CalleGarante, Cadena_Vacia);
		SET Par_NumIntGarante		:= IFNULL(Par_NumIntGarante, Cadena_Vacia);
		SET Par_NumExtGarante		:= IFNULL(Par_NumExtGarante, Cadena_Vacia);
		SET Par_ColoniaGarante		:= IFNULL(Par_ColoniaGarante, Cadena_Vacia);
		SET Par_CodPostalGarante	:= IFNULL(Par_CodPostalGarante, Cadena_Vacia);

		SET Par_EstadoIDGarante		:= IFNULL(Par_EstadoIDGarante, Entero_Cero);
		SET Par_MunicipioGarante	:= IFNULL(Par_MunicipioGarante, Entero_Cero);
		SET Par_LocalidadID			:= IFNULL(Par_LocalidadID, Entero_Cero);
		SET Par_Proporcion			:= IFNULL(Par_Proporcion, Entero_Cero);
		SET Par_Usufructuaria		:= IFNULL(Par_Usufructuaria, Con_NO);

		IF( IFNULL(Par_VencimientoPoliza, FechaVacia) = FechaVacia ) THEN
			SET Par_VencimientoPoliza := FechaVacia;
		END IF;

		IF( IFNULL(Par_FechaValuacion, FechaVacia) = FechaVacia ) THEN
			SET Par_FechaValuacion := FechaVacia;
		END IF;

		IF( IFNULL(Par_FechaVerificacion, FechaVacia) = FechaVacia ) THEN
			SET Par_FechaVerificacion := FechaVacia;
		END IF;

		IF( IFNULL(Par_FechaCompFactura, FechaVacia) = FechaVacia ) THEN
			SET Par_FechaCompFactura := FechaVacia;
		END IF;

		IF( IFNULL(Par_FechaGrevemen, FechaVacia) = FechaVacia ) THEN
			SET Par_FechaGrevemen := FechaVacia;
		END IF;

		CALL FOLIOSAPLICAACT('GARANTIAS', Par_GarantiaID);

		INSERT INTO GARANTIAS (
			GarantiaID,				ProspectoID,        	ClienteID,      		AvalID,         		GaranteID,
			GaranteNombre,			TipoGarantiaID,     	ClasifGarantiaID,   	ValorComercial, 		Observaciones,
			EstadoID,           	MunicipioID,        	Calle,          		Numero,					NumeroInt,
			Lote,               	Manzana,        		Colonia,				CodigoPostal,   		M2Construccion,
			M2Terreno,          	Asegurado,				VencimientoPoliza,  	FechaValuacion, 		NumAvaluo,

			NombreValuador,			Verificada,         	FechaVerificacion,  	TipoGravemen,   		TipoInsCaptacion,
			InsCaptacionID,     	MontoAsignado,      	Estatus,        		NoIdentificacion,		TipoDocumentoID,
			Asegurador,				NombreAutoridad,		CargoAutoridad,			FechaCompFactura,		FechaGrevemen,
			FolioRegistro,			MontoGravemen,			NombBenefiGravem,		NotarioID,				NumPoliza,
			ReferenFactura,			RFCEmisor,				SerieFactura,			ValorFactura,			FechaRegistro,

			CalleGarante,       	NumIntGarante,			NumExtGarante,			ColoniaGarante,			CodPostalGarante,
			EstadoIDGarante,		MunicipioGarante,		LocalidadID,			ColoniaID,				MontoAvaluo,
			Proporcion,				Usufructuaria,

			EmpresaID,    			Usuario,            	FechaActual,      		DireccionIP,    		ProgramaID,
			Sucursal,           	NumTransaccion)
		VALUES(
			Par_GarantiaID,         Par_ProspectoID,        Par_ClienteID,      	Par_AvalID,         	Par_GaranteID,
			Par_GaranteNombre,		Par_TipoGarantiaID,     Par_ClasifGarantiaID,   Par_ValorComercial, 	Par_Observaciones,
			Par_EstadoID,           Par_MunicipioID,        Par_Calle,          	Par_Numero,				Par_NumeroInt,
			Par_Lote,            	Par_Manzana,        	Par_Colonia,			Par_CodigoPostal,   	Par_M2Construccion,
			Par_M2Terreno,      	Par_Asegurado,			Par_VencimientoPoliza,  Par_FechaValuacion, 	Par_NumAvaluo,

			Par_NombreValuador,		Par_Verificada,         Par_FechaVerificacion,  Par_TipoGravemen,   	Par_TipoInsCaptacion,
			Par_InsCaptacionID,     Par_MontoAsignado,      Par_Estatus,    		Par_NoIdentificacion,	Par_TipoDocumentoID,
			Par_Asegurador,			Par_NombreAutoridad,	Par_CargoAutoridad,		Par_FechaCompFactura,	Par_FechaGrevemen,
			Par_FolioRegistro, 		Par_MontoGravemen,		Par_NombBenefiGravem, 	Par_NotarioID,			Par_NumPoliza,
			Par_ReferenFactura, 	Par_RFCEmisor,			Par_SerieFactura,		Par_ValorFactura,  		Par_FechaRegistro,

			Par_CalleGarante, 		Par_NumIntGarante,		Par_NumExtGarante,		Par_ColoniaGarante,		Par_CodPostalGarante,
			Par_EstadoIDGarante,	Par_MunicipioGarante,	Par_LocalidadID,		Par_ColoniaID,			Par_MontoAvaluo,
			Par_Proporcion,			Par_Usufructuaria,

			Aud_EmpresaID,          Aud_Usuario,            Aud_FechaActual,     	Aud_DireccionIP,    	Aud_ProgramaID,
			Aud_Sucursal,           Aud_NumTransaccion);

		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= CONCAT('La Garantia se ha grabado Exitosamente: ', CAST(Par_GarantiaID AS CHAR) );
		SET Var_Control		:= 'garantiaID';
		SET Var_Consecutivo	:= Par_GarantiaID;
		SET Var_FolioSalida	:= Par_GarantiaID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo	AS consecutivo;
	END IF;

END TerminaStore$$