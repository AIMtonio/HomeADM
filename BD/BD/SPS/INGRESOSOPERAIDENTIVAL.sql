-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INGRESOSOPERAIDENTIVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `INGRESOSOPERAIDENTIVAL`;
DELIMITER $$

CREATE PROCEDURE `INGRESOSOPERAIDENTIVAL`(
/* SP DE VALIDACION PARA LA IDENTIFICACION DEL CTE EN INGRESOS DE OPRACIONES
 * SI SE MODIFICA ESTE SP, MODIFICAR PAGOREMESASVAL */
	Par_OpcionCajaID	INT(11),		-- ID de la Operacion de Ventanilla
	Par_ClienteID		INT(11),		-- ID del Cliente
	Par_UsuarioID		INT(11),		-- ID del Usuario de Servicios
	Par_Monto			DECIMAL(12,2),	-- Monto de la Operacion
	Par_Salida			CHAR(1),		-- Indica si el SP genera salida

	INOUT Par_NumErr	INT,			-- Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),	-- Mensaje de Error
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

-- Declaracion de Variables
DECLARE Var_MontoLimiteA 	DECIMAL(12,2);
DECLARE Var_MontoLimiteB 	DECIMAL(12,2);
DECLARE Var_MontoLimiteC 	DECIMAL(12,2);
DECLARE	Var_MonedaID		INT(11);

DECLARE Var_TipoPersona		CHAR(1);
DECLARE Var_NombreComp	 	VARCHAR(200);
DECLARE Var_FechaNaci		DATE;
DECLARE Var_LugarNaci		INT(11);
DECLARE Var_EstadoID 		INT(11);
DECLARE Var_Nacion			CHAR(1);
DECLARE Var_PaisResi		INT(11);
DECLARE Var_CURP			CHAR(18);
DECLARE	Var_TelCelular		VARCHAR(20);
DECLARE Var_Telefono		VARCHAR(20);
DECLARE Var_Correo			CHAR(50);
DECLARE Var_RazonSocial		VARCHAR(150);
DECLARE Var_TipoSociedad 	INT(11);
DECLARE Var_RFCOficial		CHAR(13);
DECLARE Var_Sexo			CHAR(1);
DECLARE Var_OcupacionID		INT(5);
DECLARE Var_FEA				VARCHAR(250);
DECLARE Var_FechaCons		DATE;
DECLARE Var_DirCompleta		VARCHAR(200);

DECLARE Var_TipoIdenti		INT(11);
DECLARE Var_NumIdenti		VARCHAR(30);
DECLARE Var_FecExIden		DATE;
DECLARE Var_FecVenIden		DATE;
DECLARE Var_Control			VARCHAR(20);
DECLARE Var_TipoCambio		DECIMAL(14,2);
DECLARE Var_EstaSujeto		VARCHAR(1);

-- Declaracion de Constantes
DECLARE Entero_Cero			INT;
DECLARE Decimal_Cero		DECIMAL;
DECLARE Cadena_Vacia		CHAR;
DECLARE	Fecha_Vacia			DATE;
DECLARE ValorSi 			CHAR(1);
DECLARE Inactivo			CHAR(1);
DECLARE	Per_Fisica			CHAR(1);
DECLARE	Per_ActEmp			CHAR(1);
DECLARE	Per_Moral			CHAR(1);
DECLARE	Identificacion		VARCHAR(20);
DECLARE	Elector				VARCHAR(20);
DECLARE	Pasaporte			VARCHAR(20);
DECLARE	CartillaMilitar		VARCHAR(20);
DECLARE	CedulaProf			VARCHAR(20);
DECLARE	Moneda				VARCHAR(20);

DECLARE	Control			    VARCHAR(20);
DECLARE Consecutivo			INT;
DECLARE TipoDocIdentifi     INT;
DECLARE TipoDocIFE          INT;
DECLARE TipoDocCartilla     INT;
DECLARE TipoDocLicencia     INT;
DECLARE TipoDocPasaporte    INT;
DECLARE DescINE 			VARCHAR(25);
DECLARE DescIFE 			VARCHAR(25);
DECLARE DescELECTOR 		VARCHAR(25);
DECLARE DescCREDENCIAL 		VARCHAR(25);
DECLARE DescPASAPORTE 		VARCHAR(25);
DECLARE DescCARTILLA 		VARCHAR(25);
DECLARE DescCEDULA 			VARCHAR(25);
DECLARE PaisMexico			INT(11);
DECLARE EstatusVigente		VARCHAR(1);
DECLARE Str_SI				CHAR(1);
DECLARE Str_NO				CHAR(1);

-- Asignacion de Constantes
SET Entero_Cero			:= 0;			-- Entero Cero
SET Decimal_Cero		:= 0.0;			-- Decimal Cero
SET Cadena_Vacia		:= '';			-- Cadena Vacia
SET	Fecha_Vacia			:= '1900-01-01';-- Fecha vacia
SET ValorSi 			:= 'S';			-- Si
SET Inactivo			:= 'I';			-- Valor Inactivo
SET	Per_Fisica			:= 'F';			-- Tipo de Persona: Fisica
SET	Per_ActEmp			:= 'A';			-- Tipo de Persona: Fisica con Actividad Empresarial
SET	Per_Moral			:= 'M';			-- Tipo de Persona: Moral
SET Identificacion 		:= 'IDENTIFICACIONES'; 		-- Descripcion Identificaciones
SET Elector		 		:= 'ELECTOR'; 				-- Descripcion Elector
SET Pasaporte	 		:= 'PASAPORTE'; 			-- Descripcion Pasaporte
SET CartillaMilitar		:= 'CARTILLA MILITAR'; 		-- Descripcion Cartilla Militar
SET CedulaProf	 		:= 'CEDULA PROFESIONAL'; 	-- Descripcion Cedula Profesional
SET Moneda				:= 'DOLARES AMERICANOS';	-- Descripcion Moneda DOLARES AMERICANOS
SET EstatusVigente		:= 'V';			-- Estatus Vigente

-- Solo consideramos las identificaciones OFICIALES segun TIPOSIDENTI
SET TipoDocIdentifi     := 2;    		-- Tipo documento: IDENTIFICACIONES
SET DescINE 			:='%INE%';		-- Like para busqueda de Credencial del INE
SET DescIFE 			:='%IFE%';		-- Like para busqueda de Credencial del INE
SET DescELECTOR 		:='%ELECTOR%';	-- Like para busqueda de Credencial del INE
SET DescCREDENCIAL 		:='%CREDENCIAL DE ELECTOR%';-- Like para busqueda de Credencial del INE
SET DescPASAPORTE 		:='%PASAPORTE%';			-- Like para busqueda de Pasaporte
SET DescCARTILLA 		:='%CARTILLA MILITAR%';		-- Like para busqueda de Cartilla Militar
SET DescCEDULA 			:='%CEDULA PROFESIONAL%';	-- Like para busqueda de Cedula Profesional
SET PaisMexico			:= 700;			-- Clave del pais Mexico PAISES
SET Str_SI	 			:= 'S';			-- Si
SET Str_NO	 			:= 'N';			-- No

ManejoErrores:BEGIN

-- Se obtiene si la operacion de remesas es sujeta de pld para identificacion del cte
	SELECT	SujetoPLDIdenti
	INTO 	Var_EstaSujeto
		FROM OPCIONESCAJA
			WHERE OpcionCajaID=Par_OpcionCajaID;

	SET Var_EstaSujeto := IFNULL(Var_EstaSujeto,Str_NO);

	IF(Var_EstaSujeto=Str_SI)THEN
		# Se obtienen los Montos Limites por Remesa, asi como la Moneda de Cambio
		IF(NOT EXISTS(SELECT FolioID
				FROM PARAMPLDOPEEFEC
					WHERE Estatus = EstatusVigente))THEN
			SET Par_NumErr = 20;
			SET Par_ErrMen = CONCAT('No Existen Parametros Vigentes en Parametros Operaciones Operaciones en Efectivo.');
			LEAVE ManejoErrores;
		END IF;

		SELECT 	MontoRemesaUno,		MontoRemesaDos,		MontoRemesaTres,	RemesaMonedaID
		INTO 	Var_MontoLimiteA,	Var_MontoLimiteB,	Var_MontoLimiteC,	Var_MonedaID
			FROM PARAMPLDOPEEFEC
				WHERE Estatus = EstatusVigente;

		# Obtener Tipo de Cambio del Dia anterior o la ultima capturada
		SELECT ROUND(TipCamDof, 2)
			INTO Var_TipoCambio
				FROM `HIS-MONEDAS`
					WHERE MonedaID = Var_MonedaID
					ORDER BY FechaActual DESC LIMIT 1;

		# Si no hay Tipo de Cambio de dias anteriores, se obtiene el del dia actual
		IF IFNULL(Var_TipoCambio , Entero_Cero) = Entero_Cero THEN
			SELECT ROUND(TipCamDof, 2)
				INTO Var_TipoCambio
					FROM MONEDAS
						WHERE MonedaID = Var_MonedaID
						ORDER BY FechaActual DESC LIMIT 1;
		END IF;

		#Se Obtienen los ID de los Tipos de Documentos
		SELECT TipoDocumentoID INTO TipoDocIdentifi
			FROM TIPOSDOCUMENTOS
				WHERE Descripcion = Identificacion
				LIMIT 1;

		SELECT TipoDocumentoID INTO TipoDocIFE
			FROM TIPOSDOCUMENTOS
				WHERE  Descripcion LIKE DescINE
					OR Descripcion LIKE DescIFE
					OR Descripcion LIKE DescELECTOR
					OR Descripcion LIKE DescCREDENCIAL
				LIMIT 1;

		SELECT TipoDocumentoID INTO TipoDocPasaporte
			FROM TIPOSDOCUMENTOS
				WHERE Descripcion = Pasaporte
				LIMIT 1;

		SELECT TipoDocumentoID INTO TipoDocCartilla
			FROM TIPOSDOCUMENTOS
				WHERE Descripcion = CartillaMilitar
				LIMIT 1;

		# Se convierten los Montos Limites de Reversa, segÃºn el tipo de Cambio de la Moneda a que pertenece
		SET Var_MontoLimiteA := (IFNULL(Var_MontoLimiteA,Decimal_Cero) * IFNULL(Var_TipoCambio,Decimal_Cero));
		SET Var_MontoLimiteB := (IFNULL(Var_MontoLimiteB,Decimal_Cero) * IFNULL(Var_TipoCambio,Decimal_Cero));
		SET Var_MontoLimiteC := (IFNULL(Var_MontoLimiteC,Decimal_Cero) * IFNULL(Var_TipoCambio,Decimal_Cero));

		#-------DATOS CLIENTE
		IF(IFNULL(Par_ClienteID, Entero_Cero) > 0)THEN

			SELECT 		TipoPersona,		NombreCompleto,		FechaNacimiento,	LugarNacimiento, 	EstadoID,
						Nacion, 			PaisResidencia,		CURP,				TelefonoCelular,	Telefono,
						Correo,				RazonSocial,		TipoSociedadID,		RFCOficial,			Sexo,
						OcupacionID,		FEA,				FechaConstitucion

				INTO 	Var_TipoPersona,	Var_NombreComp,		Var_FechaNaci,		Var_LugarNaci,		Var_EstadoID,
						Var_Nacion,			Var_PaisResi,		Var_CURP,			Var_TelCelular,		Var_Telefono,
						Var_Correo,			Var_RazonSocial,	Var_TipoSociedad,	Var_RFCOficial,		Var_Sexo,
						Var_OcupacionID,	Var_FEA,			Var_FechaCons
				FROM CLIENTES
					WHERE ClienteID = Par_ClienteID
							AND Estatus != Inactivo AND EsMenorEdad != ValorSi
							LIMIT 1;

			SELECT DireccionCompleta INTO Var_DirCompleta
				FROM DIRECCLIENTE
					WHERE ClienteID = Par_ClienteID
						LIMIT 1;
						#AND Oficial = ValorSi;

			SELECT 	TipoIdentiID,	NumIdentific,	IFNULL(FecExIden,Fecha_Vacia) AS FecExIden,	IFNULL(FecVenIden, Fecha_Vacia) AS FecVenIden
				INTO Var_TipoIdenti, Var_NumIdenti, Var_FecExIden,	Var_FecVenIden
				FROM IDENTIFICLIENTE
					WHERE ClienteID = Par_ClienteID
						#AND	Oficial = ValorSi
					LIMIT 1;
		END IF;

		#-------DATOS USUARIO
		IF(IFNULL(Par_UsuarioID, Entero_Cero) > 0)THEN

			SELECT	TipoPersona,	NombreCompleto,		FechaNacimiento,	PaisNacimiento,	EstadoNacimiento,
					Nacionalidad,	PaisResidencia,		CURP,				TelefonoCelular,Telefono,
					Correo,			RazonSocial,		TipoSociedadID,		RFCOficial,		OcupacionID,
					FEA,			FechaConstitucion,	DirCompleta,		TipoIdentiID,	NumIdenti,
					FecExIden,		Var_FecVenIden,		Sexo

				INTO 	Var_TipoPersona,	Var_NombreComp,		Var_FechaNaci,		Var_LugarNaci,		Var_EstadoID,
						Var_Nacion,			Var_PaisResi,		Var_CURP,			Var_TelCelular,		Var_Telefono,
						Var_Correo,			Var_RazonSocial,	Var_TipoSociedad,	Var_RFCOficial,		Var_OcupacionID,
						Var_FEA,			Var_FechaCons,		Var_DirCompleta,	Var_TipoIdenti, 	Var_NumIdenti,
						Var_FecExIden,		Var_FecVenIden,		Var_Sexo
					FROM USUARIOSERVICIO
					WHERE UsuarioServicioID = Par_UsuarioID
						LIMIT 1;
		END IF;

		-- Validaciones
		IF (IFNULL(Par_Monto,Decimal_Cero) = Decimal_Cero)THEN
			SET	Par_NumErr 	:= 1;
			SET	Par_ErrMen	:= 'El Monto del Pago esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Monto > Var_MontoLimiteA) THEN
			IF (IFNULL(Var_NombreComp, Cadena_Vacia) = Cadena_Vacia) THEN
				SET	Par_NumErr 	:= 2;
				SET	Par_ErrMen	:= 'El Nombre es Requerido.';
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Var_LugarNaci, Entero_Cero) = Entero_Cero) THEN
				SET	Par_NumErr 	:= 3;
				SET	Par_ErrMen	:= 'El Pais de Nacimiento es Requerido.';
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Var_FechaNaci, Fecha_Vacia) = Fecha_Vacia AND Var_TipoPersona = 'F') THEN -- T_16118 IALDANA Se agrega TipoPersona
				SET	Par_NumErr 	:= 4;
				SET	Par_ErrMen	:= 'La Fecha de Nacimiento es Requerida.';
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Var_DirCompleta, Cadena_Vacia) = Cadena_Vacia) THEN
				SET	Par_NumErr 	:= 5;
				SET	Par_ErrMen	:= 'La Direccion es Requerida.';
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Var_TipoIdenti, Entero_Cero) = Entero_Cero) THEN
				SET	Par_NumErr 	:= 6;
				SET	Par_ErrMen	:= 'El Tipo de Identificacion es Requerido. ';
				LEAVE ManejoErrores;
			ELSE
				IF (IFNULL(Var_NumIdenti, Cadena_Vacia) = Cadena_Vacia) THEN
					SET	Par_NumErr 	:= 7;
					SET	Par_ErrMen	:= 'El Numero de Identificacion es Requerido.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (IFNULL(Var_Nacion, Cadena_Vacia) = Cadena_Vacia) THEN
				SET	Par_NumErr 	:= 8;
				SET	Par_ErrMen	:= 'La Nacionalidad es Requerida.';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_TipoPersona = Per_Moral)THEN

				IF (IFNULL(Var_RazonSocial, Cadena_Vacia) = Cadena_Vacia) THEN
					SET	Par_NumErr 	:= 9;
					SET	Par_ErrMen	:= 'La Razon Social es Requerida.';
					LEAVE ManejoErrores;
				END IF;

				IF (IFNULL(Var_TipoSociedad, Entero_Cero) = Entero_Cero) THEN
					SET	Par_NumErr 	:= 10;
					SET	Par_ErrMen	:= 'El Tipo de Sociedad es Requerido.';
					LEAVE ManejoErrores;
				END IF;

				IF (IFNULL(Var_RFCOficial, Cadena_Vacia) = Cadena_Vacia) THEN
					SET	Par_NumErr 	:= 11;
					SET	Par_ErrMen	:= 'El RFC es Requerido.';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		IF (Par_Monto > Var_MontoLimiteB AND Par_Monto < Var_MontoLimiteC) THEN

			IF(IFNULL(Par_ClienteID, Entero_Cero) > 0)THEN
				IF NOT EXISTS (SELECT ClienteArchivosID
									FROM CLIENTEARCHIVOS ca
										INNER JOIN TIPOSDOCUMENTOS td ON ca.TipoDocumento = td.TipoDocumentoID
										WHERE ((td.Descripcion LIKE DescINE
											OR td.Descripcion LIKE DescIFE
											OR td.Descripcion LIKE DescELECTOR
											OR td.Descripcion LIKE DescCREDENCIAL
											OR td.Descripcion LIKE DescPASAPORTE
											OR td.Descripcion LIKE DescCARTILLA
											OR td.Descripcion LIKE DescCEDULA)
											OR TipoDocumentoID IN(	TipoDocIdentifi,
																	TipoDocIFE,
																	TipoDocCartilla,
																	TipoDocLicencia,
																	TipoDocPasaporte))
											AND ClienteID = Par_ClienteID
											LIMIT 1)THEN
					SET	Par_NumErr 	:= 12;
					SET	Par_ErrMen	:= 'Necesita Digitalizar una Identificacion, en la Pantalla Expediente del safilocale.cliente';
					LEAVE ManejoErrores;

				END IF;
			END IF;

			IF(IFNULL(Par_UsuarioID, Entero_Cero) > 0)THEN
				IF NOT EXISTS (SELECT UsuarioSerArchiID
									FROM USUARIOSERARCHIVO ua
										INNER JOIN TIPOSDOCUMENTOS td ON ua.TipoDocumento = td.TipoDocumentoID
										WHERE ((td.Descripcion LIKE DescINE
											OR td.Descripcion LIKE DescIFE
											OR td.Descripcion LIKE DescELECTOR
											OR td.Descripcion LIKE DescCREDENCIAL
											OR td.Descripcion LIKE DescPASAPORTE
											OR td.Descripcion LIKE DescCARTILLA
											OR td.Descripcion LIKE DescCEDULA)
											OR TipoDocumentoID IN(	TipoDocIdentifi,
																	TipoDocIFE,
																	TipoDocCartilla,
																	TipoDocLicencia,
																	TipoDocPasaporte))
											AND UsuarioServicioID = Par_UsuarioID
											LIMIT 1)THEN
					SET	Par_NumErr 	:= 12;
					SET	Par_ErrMen	:= 'Necesita Digitalizar una Identificacion, en la Pantalla de Usuario Servicios';
					LEAVE ManejoErrores;

				END IF;
			END IF;
		END IF;

		IF (Par_Monto > Var_MontoLimiteC) THEN
			IF(IFNULL(Par_ClienteID, Entero_Cero) > 0)THEN
				IF NOT EXISTS (SELECT ClienteArchivosID
									FROM CLIENTEARCHIVOS ca
										INNER JOIN TIPOSDOCUMENTOS td ON ca.TipoDocumento = td.TipoDocumentoID
										WHERE ((td.Descripcion LIKE DescINE
											OR td.Descripcion LIKE DescIFE
											OR td.Descripcion LIKE DescELECTOR
											OR td.Descripcion LIKE DescCREDENCIAL
											OR td.Descripcion LIKE DescPASAPORTE
											OR td.Descripcion LIKE DescCARTILLA
											OR td.Descripcion LIKE DescCEDULA)
											OR TipoDocumentoID IN(	TipoDocIdentifi,
																	TipoDocIFE,
																	TipoDocCartilla,
																	TipoDocLicencia,
																	TipoDocPasaporte))
											AND ClienteID = Par_ClienteID
											LIMIT 1)THEN
					SET	Par_NumErr 	:= 12;
					SET	Par_ErrMen	:= 'Necesita Digitalizar una Identificacion, en la Pantalla Expediente del safilocale.cliente';
					LEAVE ManejoErrores;

				END IF;
			END IF;

			IF(IFNULL(Par_UsuarioID, Entero_Cero) > 0)THEN
				IF NOT EXISTS (SELECT UsuarioSerArchiID
									FROM USUARIOSERARCHIVO ua
										INNER JOIN TIPOSDOCUMENTOS td ON ua.TipoDocumento = td.TipoDocumentoID
										WHERE ((td.Descripcion LIKE DescINE
											OR td.Descripcion LIKE DescIFE
											OR td.Descripcion LIKE DescELECTOR
											OR td.Descripcion LIKE DescCREDENCIAL
											OR td.Descripcion LIKE DescPASAPORTE
											OR td.Descripcion LIKE DescCARTILLA
											OR td.Descripcion LIKE DescCEDULA)
											OR TipoDocumentoID IN(	TipoDocIdentifi,
																	TipoDocIFE,
																	TipoDocCartilla,
																	TipoDocLicencia,
																	TipoDocPasaporte))
											AND UsuarioServicioID = Par_UsuarioID
											LIMIT 1)THEN
					SET	Par_NumErr 	:= 12;
					SET	Par_ErrMen	:= 'Necesita Digitalizar una Identificacion, en la Pantalla de Usuario Servicios';
					LEAVE ManejoErrores;

				END IF;
			END IF;

			IF (IFNULL(Var_Sexo, Cadena_Vacia) = Cadena_Vacia) THEN
				SET	Par_NumErr 	:= 13;
				SET	Par_ErrMen	:= 'El Sexo es Requerido.';
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Var_LugarNaci,Entero_Cero) = PaisMexico)THEN
				IF (IFNULL(Var_EstadoID, Entero_Cero) = Entero_Cero) THEN
					SET	Par_NumErr 	:= 14;
					SET	Par_ErrMen	:= 'El Estado de Nacimiento es Requerido.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (IFNULL(Var_OcupacionID, Entero_Cero) = Entero_Cero) THEN
				SET	Par_NumErr 	:= 15;
				SET	Par_ErrMen	:= 'La Ocupacion es Requerida.';
				LEAVE ManejoErrores;
			END IF;

			IF((IFNULL(Var_Telefono,Cadena_Vacia) = Cadena_Vacia) AND (IFNULL(Var_Correo,Cadena_Vacia) = Cadena_Vacia))THEN
				IF(IFNULL(Var_TelCelular,Cadena_Vacia)=Cadena_Vacia)THEN
					SET Par_NumErr := 16;
					SET Par_ErrMen := 'El Telefono Celular es requerido.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF((IFNULL(Var_TelCelular,Cadena_Vacia) = Cadena_Vacia) AND (IFNULL(Var_Correo,Cadena_Vacia) = Cadena_Vacia))THEN
				IF(IFNULL(Var_Telefono,Cadena_Vacia)=Cadena_Vacia)THEN
					SET Par_NumErr := 17;
					SET Par_ErrMen :=	'El Telefono es requerido.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF((IFNULL(Var_Telefono,Cadena_Vacia) = Cadena_Vacia) AND (IFNULL(Var_TelCelular,Cadena_Vacia) = Cadena_Vacia))THEN
				IF(IFNULL(Var_Correo,Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr := 18;
					SET Par_ErrMen :=	'El Correo Electronico es requerido.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (IFNULL(Var_CURP, Cadena_Vacia) = Cadena_Vacia) THEN
				SET	Par_NumErr 	:= 19;
				SET	Par_ErrMen	:= 'La CURP es Requerida.';
				LEAVE ManejoErrores;
			END IF;

		END IF;
	END IF;

	SET	Par_NumErr	:= 00;
	SET	Par_ErrMen	:= 'Validacion Exitosa';

END ManejoErrores;

SET	Consecutivo	:= Entero_Cero;

IF(IFNULL(Par_ClienteID, Entero_Cero) > 0)THEN
 	SET	Control	:= 'clienteIDServicio';
	IF(Par_NumErr != 12 ) THEN
		SET Par_ErrMen := CONCAT(Par_ErrMen, ' Flujo de safilocale.cliente');
	END IF;
END IF;

IF(IFNULL(Par_UsuarioID, Entero_Cero) > 0)THEN
	SET	Control	:= 'usuarioRem';
	IF(Par_NumErr != 12) THEN
		SET Par_ErrMen := CONCAT(Par_ErrMen, ' Pantalla de Usuario de Servicios.');
	END IF;
END IF;

# ======================== LANZA VALORES DE RESPUESTA ========================

IF(Par_Salida = ValorSi) THEN
	SELECT
		Par_NumErr			AS NumErr,
		Par_ErrMen 			AS ErrMen,
		Control 			AS control,
		Consecutivo			AS consecutivo;
END IF;

END TerminaStore$$
