-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GARANTIASAGROACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `GARANTIASAGROACT`;

DELIMITER $$
CREATE PROCEDURE `GARANTIASAGROACT`(

	/* SP PARA LA ACTUALIZACION DE GARANTIAS */
	Par_GarantiaID      	INT(11),		-- Numero de la garantia
	Par_ProspectoID	  	 	BIGINT(20),		-- Numero del prospecto
	Par_ClienteID	        INT(11),		-- Numero del cliete
	Par_AvalID	            INT(11),		-- Numero del aval
	Par_GaranteID	        INT(11),		-- ID del garante

	Par_GaranteNombre		VARCHAR(100),	-- Nombre del garante
	Par_TipoGarantiaID		INT(11),		-- Tipo de garantia
	Par_ClasifGarantiaID	INT(11), 		-- Clasificacion de la garantia
	Par_ValorComercial		DECIMAL(16,2), 	-- Valor comercial de la garantia
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
	Par_NumPoliza			BIGINT(12), 	-- Numero de poliza

	Par_ReferenFactura		VARCHAR(45), 	-- Referencia de la factuara
	Par_RFCEmisor			VARCHAR(45),	-- RFC del emision
	Par_SerieFactura		VARCHAR(45), 	-- numero de serie factura o documento
	Par_ValorFactura		VARCHAR(45), 	-- Valor de la factura
	Par_FechaRegistro		DATE,			-- Fecha de registro

	Par_CalleGarante		VARCHAR(70),	-- Direccion de garante
	Par_NumIntGarante		VARCHAR(45),	-- Numero interior
	Par_NumExtGarante		VARCHAR(45), 	-- Numero exterior
	Par_ColoniaGarante		VARCHAR(65),	-- colonia
	Par_CodPostalGarante	VARCHAR(45), 	-- codigo postal

	Par_EstadoIDGarante		INT(11),		-- Estado del garante
	Par_MunicipioGarante	INT(11), 		-- fin direccion de garante

	Par_LocalidadID			INT(11), 		-- Id de la localidad
	Par_ColoniaID			INT(11), 		-- Id de la colonia
	Par_MontoAvaluo     	DECIMAL(21,2),	-- Monto de Valuacion de la garantia
	Par_Proporcion			DECIMAL (14,2),
	Par_Usufructuaria		CHAR (1),

	Par_Salida 				CHAR(1),
	INOUT	Par_NumErr	 	INT(11),
	INOUT	Par_ErrMen	 	VARCHAR(400),
	INOUT	Var_FolioSalida	INT,

	Aud_EmpresaID	    	INT(11),			-- Parametros de Auditoria --
	Aud_Usuario	        	INT(11),			-- Parametros de Auditoria --
	Aud_FechaActual			DATETIME ,			-- Parametros de Auditoria --
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria --
	Aud_ProgramaID	    	VARCHAR(150),		-- Parametros de Auditoria --
	Aud_Sucursal	    	INT(11),			-- Parametros de Auditoria --
	Aud_NumTransaccion		BIGINT(20) 			-- Parametros de Auditoria --
		)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control		VARCHAR(30);	-- Variable de control
	DECLARE Var_Consecutivo	INT(11);		-- Consecutivo de registro

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);		-- Constante Entero Cero
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia
	DECLARE Salida_SI			CHAR(1);		-- Constante Salida SI
	DECLARE Salida_NO			CHAR(1);		-- Constante Salida NO
	DECLARE Con_NO				CHAR(1);		-- Constante NO

	DECLARE Con_LibreGravamen	CHAR(1);		-- Constante Libre de Gravamen
	DECLARE FechaVacia			DATE;			-- Constante Fecha Vacia

	-- Declaracion de Actualizaciones
	DECLARE Act_MontoHipoteca	TINYINT UNSIGNED;	-- Actualizacion 1.- Monto de Garantia Hipotecaria

	-- Asignacion de constantes
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';
	SET Con_NO				:= 'N';

	SET Con_LibreGravamen	:= 'L';
	SET FechaVacia			:= '1900-01-01';

	-- Asignacion de Actualizaciones
	SET Act_MontoHipoteca 	:= 1;

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-GARANTIASAGROACT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		IF NOT EXISTS (SELECT GarantiaID FROM GARANTIAS WHERE GarantiaID = Par_GarantiaID) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= CONCAT('No Existe el Folio de Garantia');
			SET Var_Control	:= 'garantiaID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_ProspectoID	 		:= IFNULL(Par_ProspectoID, Entero_Cero);
		SET Par_ClienteID	 		:= IFNULL(Par_ClienteID, Entero_Cero);
		SET Par_AvalID		 		:= IFNULL(Par_AvalID, Entero_Cero);
		SET Par_GaranteID	 		:= IFNULL(Par_GaranteID, Entero_Cero);

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
		SET Par_ColoniaID			:= IFNULL(Par_ColoniaID, Entero_Cero);
		SET Par_MontoAvaluo			:= IFNULL(Par_MontoAvaluo, Entero_Cero);

		SET Par_Proporcion			:= IFNULL(Par_Proporcion, Entero_Cero);
		SET Par_Usufructuaria		:= IFNULL(Par_Usufructuaria, Con_NO);

		SET Aud_EmpresaID			:= IFNULL(Aud_EmpresaID, Entero_Cero);
		SET Aud_Usuario				:= IFNULL(Aud_Usuario, Entero_Cero);
		SET Aud_FechaActual			:= IFNULL(Aud_FechaActual, NOW());
		SET Aud_DireccionIP			:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
		SET Aud_ProgramaID			:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
		SET Aud_Sucursal			:= IFNULL(Aud_Sucursal, Entero_Cero);
		SET Aud_NumTransaccion		:= IFNULL(Aud_NumTransaccion, Entero_Cero);

		-- Se actualiza el monto tipoGravemen
		IF( Par_TipoGravemen != Con_LibreGravamen ) THEN
			CALL CREGARPRENHIPOACT (
				Par_GarantiaID,		Act_MontoHipoteca,
				Salida_NO,			Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		UPDATE	GARANTIAS	SET
			ProspectoID   			= Par_ProspectoID,
			ClienteID       		= Par_ClienteID,
			AvalID        			= Par_AvalID,
			GaranteID    			= Par_GaranteID,
			GaranteNombre			= Par_GaranteNombre,

			TipoGarantiaID			= Par_TipoGarantiaID,
			ClasifGarantiaID		= Par_ClasifGarantiaID,
			ValorComercial			= Par_ValorComercial,
			Observaciones			= Par_Observaciones,
			EstadoID      			= Par_EstadoID,

			MunicipioID    			= Par_MunicipioID,
			Calle         			= Par_Calle,
			Numero       			= Par_Numero,
			NumeroInt     			= Par_NumeroInt,
			Lote            		= Par_Lote,

			Manzana       			= Par_Manzana,
			Colonia      			= Par_Colonia,
			CodigoPostal  			= Par_CodigoPostal,
			M2Construccion  		= Par_M2Construccion,
			M2Terreno     			= Par_M2Terreno,

			Asegurado    			= Par_Asegurado,
			VencimientoPoliza		= Par_VencimientoPoliza,
			FechaValuacion  		= Par_FechaValuacion,
			NumAvaluo     			= Par_NumAvaluo,
			NombreValuador			= Par_NombreValuador,

			Verificada    			= Par_Verificada,
			FechaVerificacion		= Par_FechaVerificacion,
			TipoGravemen  			= Par_TipoGravemen,
			TipoInsCaptacion		= Par_TipoInsCaptacion,
			InsCaptacionID			= Par_InsCaptacionID,

			MontoAsignado   		= Par_MontoAsignado,
			Estatus       			= Par_Estatus,
			EmpresaID    			= Aud_EmpresaID,
			NoIdentificacion 		= Par_NoIdentificacion,
			TipoDocumentoID			= Par_TipoDocumentoID,

			Asegurador				= Par_Asegurador,
			NombreAutoridad			= Par_NombreAutoridad,
			CargoAutoridad			= Par_CargoAutoridad,
			FechaCompFactura 		= Par_FechaCompFactura,
			FechaGrevemen			= Par_FechaGrevemen,

			FolioRegistro			= Par_FolioRegistro,
			MontoGravemen			= Par_MontoGravemen,
			NombBenefiGravem 		= Par_NombBenefiGravem,
			NotarioID				= Par_NotarioID,
			NumPoliza				= Par_NumPoliza,

			ReferenFactura			= Par_ReferenFactura,
			RFCEmisor				= Par_RFCEmisor,
			SerieFactura			= Par_SerieFactura,
			ValorFactura			= Par_ValorFactura,
			FechaRegistro			= Par_FechaRegistro,

			CalleGarante 			= Par_CalleGarante,
			NumIntGarante			= Par_NumIntGarante,
			NumExtGarante			= Par_NumExtGarante,
			ColoniaGarante			= Par_ColoniaGarante ,
			CodPostalGarante		= Par_CodPostalGarante,

			EstadoIDGarante			= Par_EstadoIDGarante ,
			MunicipioGarante		= Par_MunicipioGarante,
			LocalidadID				= Par_LocalidadID,
			ColoniaID				= Par_ColoniaID,
			MontoAvaluo				= Par_MontoAvaluo,

			Proporcion				= Par_Proporcion,
			Usufructuaria			= Par_Usufructuaria,

			Usuario					= Aud_Usuario,
			FechaActual				= Aud_FechaActual,
			DireccionIP				= Aud_DireccionIP,
			ProgramaID				= Aud_ProgramaID,
			Sucursal				= Aud_Sucursal,
			NumTransaccion			= Aud_NumTransaccion
		WHERE GarantiaID	= Par_GarantiaID;

		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= CONCAT("Garantia Modificada Exitosamente: ",CONVERT(Par_GarantiaID,CHAR)) ;
		SET Var_Control		:= 'garantiaID';
		SET Var_Consecutivo	:= Par_GarantiaID;

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS control,
				Var_Consecutivo	AS consecutivo;
	END IF;

END TerminaStore$$