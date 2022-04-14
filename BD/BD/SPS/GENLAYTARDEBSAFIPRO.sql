-- GENLAYTARDEBSAFIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENLAYTARDEBSAFIPRO`;
DELIMITER $$

CREATE PROCEDURE `GENLAYTARDEBSAFIPRO`(
	Par_LoteDebSAFIID		INT(11),
	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT(12),

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

-- Variables
DECLARE Var_TarLayDebSAFIID 	BIGINT(11);
DECLARE Var_LoteDebSAFIID		INT(11);
DECLARE Var_ServiceCode			INT(11);
DECLARE Var_FechaVigencia		DATE;
DECLARE Var_TotalReg			INT(11);
DECLARE Var_SaltoLin			INT(11);
DECLARE Var_EsAdicional 		CHAR(1);
DECLARE Var_NumTarjeta			VARCHAR(16);
DECLARE Var_CVV 				CHAR(3);
DECLARE Var_FechaVencimiento	CHAR(5);
DECLARE Var_NIP					VARCHAR(50);
DECLARE Var_LayoutTarDeb		VARCHAR(500);
DECLARE Var_DescripcionTarje	VARCHAR(50);
DECLARE Var_TarBinParamsID		INT(11);	-- Identificador del parametro Bin
DECLARE Var_FechaSistema		DATE;		-- Fecha del sistema
DECLARE Var_ClabeMarca			CHAR(3);	-- Clabe de la marca de tarjeta

DECLARE Var_Digito1Cuenta	CHAR(4);
DECLARE Var_Digito2Cuenta	CHAR(4);
DECLARE Var_Digito3Cuenta	CHAR(4);
DECLARE Var_Digito4Cuenta	CHAR(4);

-- variables de entrada para SP: TARENTREGACARRIERALT
DECLARE Var_NombreClienteTbl			VARCHAR(21);
DECLARE Var_CalleNoTbl             		VARCHAR(27);
DECLARE Var_ColoniaTbl             		VARCHAR(40);
DECLARE Var_CiudadTbl			        VARCHAR(30);
DECLARE Var_EstadoTbl              		VARCHAR(25);
DECLARE Var_CPTbl                  		VARCHAR(5);
DECLARE Var_NumSucursalTbl         		VARCHAR(3);
DECLARE Var_NumLoteTbl			        VARCHAR(8);
DECLARE Var_NumClienteTbl				VARCHAR(8);
DECLARE Var_TipoTarjetaTbl				VARCHAR(4);
DECLARE Var_EsTitularOAdicionalTbl		CHAR(1);
DECLARE Var_EsRepoNuevaRenoTbl     		CHAR(1);
DECLARE Var_Consecutivo					VARCHAR(6);
DECLARE Var_TipoTarjetaDebID			INT(11);

DECLARE	Var_ContaRegis		INT(11);
DECLARE Var_FechaActual		DATETIME;
DECLARE Sta_Solici        	INT(11);
DECLARE Var_Cadena_Cero		CHAR(1);
DECLARE Var_NumTitual		INT(11);
DECLARE Var_Control			VARCHAR(30);

DECLARE Num_Solici			INT(11);
DECLARE FechaSolici			DATE;
DECLARE Num_Sucurs			CHAR(5);
DECLARE SAFI_CantTarj		INT(11);
DECLARE Tipo_Tarjeta		CHAR(4);
DECLARE Vigencia_Meses		INT(11);
DECLARE ColorPlastico		CHAR(2);
DECLARE DireccionIP			VARCHAR(15);
DECLARE Sucursal 			INT(11);
DECLARE EsAdicional 		CHAR(1);
DECLARE DescripcionTarje	VARCHAR(50);
DECLARE ServiceCode			CHAR(3);
DECLARE FechaVigencia		DATE;
DECLARE Var_FechaVigenciamy	CHAR(5);
DECLARE NumTransaccion		BIGINT(20);
DECLARE Var_CLABE		    VARCHAR(16);

-- VARIABLE LAYOUT
DECLARE	Var_Index			VARCHAR(6);
DECLARE Var_Line1			CHAR(1);
DECLARE Var_Cuenta			VARCHAR(19);
DECLARE Var_Line2			CHAR(1);
DECLARE Var_FechaExp		CHAR(5);
DECLARE Var_ICVV			CHAR(4);
DECLARE Var_Line4			CHAR(1);
DECLARE Var_NombreTH		VARCHAR(21);
DECLARE Var_Linea5			CHAR(1);
DECLARE Var_Empresa			VARCHAR(21);		-- Vacio solo es para tarjetas corporativas
DECLARE Var_Linea6			CHAR(1);
DECLARE Var_CVV2			VARCHAR(8);
DECLARE Var_CVV2_Complet	VARCHAR(8);
DECLARE Var_EncComChar		CHAR(1);
DECLARE Var_StSenTrack1		CHAR(1);
DECLARE Var_FormatCod		CHAR(1);
DECLARE Var_PAN				VARCHAR(16);		-- Este valor va si siempre que la tarjeta es la primaria
DECLARE Var_SepCamp			CHAR(1);
DECLARE Var_SepCampArro		CHAR(1);
DECLARE Var_SepCampAper		CHAR(1);
DECLARE Var_EncNombreTH		VARCHAR(21);
DECLARE Var_EncFecExp		CHAR(5);			-- Fecha de Expedición en formato y/M
DECLARE Var_ServCode		CHAR(3);
DECLARE Var_VisaReser		CHAR(2);
DECLARE Var_PvvVisa			CHAR(5);
DECLARE Var_VisaResCVV		CHAR(3);
DECLARE Var_Ceros			CHAR(5);
DECLARE Var_VisaRes2		VARCHAR(6);
DECLARE Var_EndSenTrack1	CHAR(1);
DECLARE Var_StartSenTrack2	CHAR(1);
DECLARE Var_SepCamIgual		CHAR(1);
DECLARE Var_EndSenTrack2	CHAR(1);
DECLARE Var_SepCamGuion		CHAR(1);
DECLARE Var_SepCamPComa		CHAR(1);
DECLARE Var_25ceros 		CHAR(25);
DECLARE Var_PinBlock		VARCHAR(16);

DECLARE Var_EsTiOAdic		CHAR(1);
DECLARE Var_RepNueReno		CHAR(1);

DECLARE Var_CadenaAper		CHAR(1);

-- Constantes
DECLARE CadenaN			CHAR(1);
DECLARE Espacio_Vacio	VARCHAR(1);
DECLARE Cadena_Vacia	CHAR(1);
DECLARE	Entero_Cero		INT(1);
DECLARE Entero_Uno		INT(1);
DECLARE SalidaSI		CHAR(1); 		# Constante Cadena Si
DECLARE SalidaNo		CHAR(1); 		# Constante Salida No
DECLARE Fecha_Vacia		DATE; 			# Constante Fecha Vacía
DECLARE Cadena_P		CHAR(1);		# Cadena P proceso
DECLARE Incremental		INT(11);		# Parametro para uso en while
DECLARE CadenaS			CHAR(1);
DECLARE Estatus_Creada	INT(11);		# Estatus creado
DECLARE Decimal_Cero    DECIMAL(12,2);
DECLARE GeneradoSI		CHAR(1);
DECLARE GeneradoNO		CHAR(1);
DECLARE Personalizado 	CHAR(1);
DECLARE Var_EsPersonalizado	CHAR(1);	# Variable que identifica si es un lote personalizado
DECLARE Var_NomPersona	VARCHAR(21);
DECLARE Var_EsVirtual	CHAR(1);		# Variable que indca si es lote de tarjeta virtual
DECLARE LotTarVirtualSI	CHAR(1);		# Si es lote de tarjeta virtual
DECLARE LotTarVirtualNO	CHAR(1);		# No es lote de tarjeta virtual
DECLARE TipTarjetaDeb	CHAR(1);		# Identificador de tipo de tarjeta debito
DECLARE TipTarjetaCred	CHAR(1);		# Identificador de tipo de tarjeta credito
DECLARE DescripTar 		VARCHAR(50);	# Descripción de la creación de tarjeta
DECLARE Var_TipoTarjeta CHAR(1);		# Identifica si es tarjeta de debito o credito

-- Asignación de Constantes
SET CadenaN				:= 'N';
SET Var_CadenaAper		:= '&';			# Cadena &
SET Espacio_Vacio		:= ' ';			# Espacio Vacio
SET CadenaS				:= 'S';
SET Var_Cadena_Cero		:= '0';			# Cadena cero
SET Estatus_Creada		:= 2;			# Estatus creado
SET Decimal_Cero        := 0.0;             # Constante DECIMAL cero

SET Entero_Cero 		:= 0;				# Constante cero
SET SalidaSI			:= 'S'; 			# Constante Cadena Si
SET SalidaNo 			:= 'N'; 			# Constante Salida No
SET Cadena_Vacia		:= '';				# Cadena Vacia
SET Var_NumTitual		:= 1;				# Es tarjeta titular
SET Fecha_Vacia			:= '1900-01-01'; 	# Constante Fecha Vacía
SET Sta_Solici        	:= 1; 				# Valor de estatus Tarjetas Solicitadas
SET Entero_Uno			:= 1;				# Constante entero uno
SET Cadena_P			:= 'P';				# Cadena P proceso
SET Incremental			:= 0;
SET GeneradoSI			:='S';
SET GeneradoNO			:='N';
SET Personalizado  		:= 'S';				# Indica que es personalizado
SET LotTarVirtualSI		:= 'S';				# Si es lote de tarjeta virtual
SET LotTarVirtualNO		:= 'N';				# No es lote de tarjeta virtual
SET TipTarjetaDeb 		:= 'D';				# Identificador de tipo de tarjeta debito
SET TipTarjetaCred		:= 'C';				# Identificador de tipo de tarjeta credito
SET DescripTar 			:= 'GENERACION DE TARJETA OPC. TGS';

-- Constantes layout
SET Var_Index			:= '000000';				-- Pocisión  6:1-6
SET Var_Line1 			:= '$';						-- Posición  1:7-7
SET Var_Line2			:= '*';						-- Posición  1:27-27
SET Var_Line4			:= ')';						-- Posición  1:37-37
SET Var_NombreTH		:= 'XXXXXXXXXXXXXXXXXXXXX';	-- Posición 21:38-58 -- Nombre Cliente Grabado en la tarjeta (no necesaria mente sea el nombre del cliente)
SET Var_Linea5			:= '#';						-- Posición  1:59-59
SET Var_Empresa			:= '                     ';	-- Posición 21:60-80
SET Var_Linea6			:= ':';						-- Posición  1:81-81
SET Var_CVV2			:= '0000 000';				-- Posición  8:82-89 -- Valor para fines de pruebas
SET Var_EncComChar		:= '"';						-- Posición  1:90-90
SET Var_StSenTrack1		:= '%';						-- Posición  1:91-91
SET Var_FormatCod		:= 'B';						-- Posición  1:92-92
SET Var_SepCamp			:= '^';						-- Posición  1:109-109
SET Var_SepCampArro		:= '@';						-- Posición  1:207-207
SET Var_EncNombreTH 	:= 'XXXXXXXXXXXXXXXXXXXXX';	-- Posición 21:110-130 -- Nombre Cliente Grabado en la tarjeta (puede o no puede ir)
SET Var_EncFecExp		:= '2001';					-- Posición  4:132-135
SET Var_ServCode		:= '000';					-- Posición  3:136-138
SET Var_VisaReser		:= '00';					-- Posición  2:139-140
SET Var_VisaResCVV		:= '000';					-- Posición  3:141-143
SET Var_VisaRes2		:= '000000';				-- Posición  6:144-149
SET Var_EndSenTrack1	:= '?';						-- Posición  1:150-150
SET Var_StartSenTrack2	:= ';';						-- Posición  1:151-151
SET Var_SepCamIgual		:= '=';						-- Posición  1:168-168
SET Var_PvvVisa			:= '00000';					-- Posicion  5:176-180
SET Var_EndSenTrack2	:= '?';						-- Posición  1:179-179
SET Var_SepCamGuion		:= '-';						-- Posición  1:180-180
SET Var_SepCamPComa		:= ';';						-- Posición  1:181-181
SET Var_Ceros			:= '00000';					-- Posicion  5:184-188
SET Var_25ceros			:= '0000000000000000000000000';
SET Var_EsTiOAdic		:= 'T';						-- Posición  1:396-396
SET Var_RepNueReno		:= 'N';						-- Posición  1:398-398
SET Var_SepCampAper		:= '&';						-- Posición  1:399-399

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: SP-GENLAYTARDEBSAFIPRO');
		SET Var_Control:= 'SQLEXCEPTION' ;
	END;

		SET Var_FechaActual := NOW();

		-- SE RECORRE LA TABLA PARA SABER LA CANTIDAD DE REGISTROS
		SELECT COUNT(TarLayDebSAFIID)
			INTO Var_TotalReg
		FROM TARLAYDEBSAFI
			WHERE EsGenerado = 'N';

		SELECT 		LOT.LoteDebSAFIID,		LOT.ServiceCode,	TIT.VigenciaMeses,		LOT.EsAdicional,	LOT.TipoTarjetaDebID,
					TIT.Descripcion,		TIT.TarBinParamsID,	LOT.EsPersonalizado, 	LOT.EsVirtual,		TIT.TipoTarjeta
			INTO 	Var_LoteDebSAFIID,		Var_ServiceCode, 	Vigencia_Meses,			Var_EsAdicional,	Var_TipoTarjetaDebID,
					Var_DescripcionTarje, 	Var_TarBinParamsID, Var_EsPersonalizado,	Var_EsVirtual, 		Var_TipoTarjeta
		FROM		LOTETARJETADEBSAFI	LOT
		INNER JOIN	TIPOTARJETADEB	TIT
			ON	TIT.TipoTarjetaDebID	= LOT.TipoTarjetaDebID
			AND	LOT.Estatus	= Sta_Solici;

		-- SE OBTIENE LA FECHA DEL SISTEMA PARA CALCULAR LA VIGENCIA
		SELECT FechaSistema
			INTO Var_FechaSistema
		FROM PARAMETROSSIS LIMIT 1;

		SET Var_FechaVigencia := DATE(DATE_ADD(Var_FechaSistema, INTERVAL Vigencia_Meses MONTH));

		CASE Var_EsVirtual
			WHEN LotTarVirtualNO THEN

				IF(Var_EsPersonalizado = Personalizado)THEN
					-- SE CREA TABLA TEMPORAL PARA
					DROP TABLE IF EXISTS TMP_TARLOTENOMBREPERSON;
					CREATE TABLE TMP_TARLOTENOMBREPERSON(
						NomPersona VARCHAR(21)
					);

					-- INSERT DE REGISTROS A PROCESAR CUANDO ES TARJETA PERSONALIZADA
					INSERT INTO TMP_TARLOTENOMBREPERSON(NomPersona)
					SELECT NombrePerso
					FROM TARLOTENOMBREPERSON
						WHERE LoteDebID = Var_LoteDebSAFIID;
				END IF;

				-- SE OBTIENE EL TIPO DE TARJETA QUE SE VA A GENERAR
				SELECT CM.Clabe
					INTO Var_ClabeMarca
				FROM TARBINPARAMS TB
					INNER JOIN CATMARCATARJETA CM
						ON TB.CatMarcaTarjetaID = CM.CatMarcaTarjetaID
					WHERE TarBinParamsID =  Var_TarBinParamsID;

				IF (Var_EsAdicional = CadenaN)THEN
					SET Var_EsTitularOAdicionalTbl	:= 'T';
					ELSEIF(Var_EsAdicional = CadenaS)THEN
						SET Var_EsTitularOAdicionalTbl	:= 'A';
				END IF;

				-- SE OBTIENE LA INFORMACIÓN CONFIGURADA DE LA TABLA TARENTREGACARRIER
		        SELECT 		NombreCliente, 			CalleNo, 			Colonia, 		Ciudad, 		Estado,
		        			CP, 					NumSucursal, 		NumLote, 		NumCliente,
		        			Consecutivo, 			EsRepoNuevaReno
		        	INTO 	Var_NombreClienteTbl,	Var_CalleNoTbl,		Var_ColoniaTbl,	Var_CiudadTbl,		Var_EstadoTbl,
		        			Var_CPTbl,				Var_NumSucursalTbl,	Var_NumLoteTbl,	Var_NumClienteTbl,
		        			Var_Consecutivo,		Var_EsRepoNuevaRenoTbl
		    	FROM TARENTREGACARRIER
		        	WHERE EsTitularOAdicional = Var_EsTitularOAdicionalTbl
		        		AND EsRepoNuevaReno = 'N' LIMIT 1;

		        -- SE RELLENAN LOS ESPACIOS PARA OCUPAR LAS POSICIONES QUE ESPERA EL LAYOUT
				SET Var_NombreClienteTbl		:= REPLACE(RPAD(Var_NombreClienteTbl,21,Var_CadenaAper),Var_CadenaAper,Espacio_Vacio);
				SET Var_CalleNoTbl            	:= REPLACE(RPAD(Var_CalleNoTbl,27,Var_CadenaAper),Var_CadenaAper,Espacio_Vacio);
				SET Var_ColoniaTbl            	:= REPLACE(RPAD(Var_ColoniaTbl,40,Var_CadenaAper),Var_CadenaAper,Espacio_Vacio);
				SET Var_CiudadTbl			    := REPLACE(RPAD(Var_CiudadTbl,30,Var_CadenaAper),Var_CadenaAper,Espacio_Vacio);
				SET Var_EstadoTbl              	:= REPLACE(RPAD(Var_EstadoTbl,25,Var_CadenaAper),Var_CadenaAper,Espacio_Vacio);
				SET Var_CPTbl                  	:= REPLACE(RPAD(Var_CPTbl,5,Var_CadenaAper),Var_CadenaAper,Espacio_Vacio);
				SET Var_NumSucursalTbl         	:= LPAD(Var_NumSucursalTbl,3,Var_Cadena_Cero);
				SET Var_NumLoteTbl			    := LPAD(Var_NumLoteTbl,8,Var_Cadena_Cero);
				SET Var_NumClienteTbl			:= LPAD(Var_NumClienteTbl,8,Var_Cadena_Cero);
				SET Var_TipoTarjetaTbl			:= LPAD(Var_ClabeMarca,4,Var_Cadena_Cero);
				SET Var_Consecutivo				:= LPAD(Var_Consecutivo,6,Var_Cadena_Cero);

				SET Var_ServCode	:= Var_ServiceCode;
				SET Var_NombreTH 	:= REPLACE(RPAD(Var_DescripcionTarje,21, Var_CadenaAper),Var_CadenaAper,Espacio_Vacio);
		        SET Var_EncNombreTH	:= REPLACE(RPAD(Var_DescripcionTarje,21, Var_CadenaAper),Var_CadenaAper,Espacio_Vacio);

		    ELSE BEGIN END;
		END CASE;

        -- SE OBTIENE EL ULTIMO REGISTRO
        SET Var_SaltoLin	:= (Var_TotalReg - Entero_Uno);
        -- PROCESO CREACIÓN DE CADENA LAYOUT
        SET Incremental := Entero_Cero;
		WHILE Incremental < Var_TotalReg DO

			-- LIMPIAN CAMPOS
			SET Var_Cuenta 		:= 'XXXX XXXX XXXX XXXX'; 	-- Posición 19:8-26
			SET Var_ICVV		:= 'XXX,';					-- Posición  3:33-36
			SET Var_PAN			:= 'XXXXXXXXXXXXXXXX';		-- Posición 16:93-108 -- Valor el mismo que el numero de la tarjeta sin espacios(solo si es tarjeta primaria)
			SET Var_TarLayDebSAFIID	:= Entero_Cero;
			SET Var_NumTarjeta		:= Cadena_Vacia;
			SET Var_CVV  			:= Cadena_Vacia;
			SET Var_ICVV 			:= Cadena_Vacia;
			SET Var_CVV2 			:= Cadena_Vacia;
			SET Var_FechaVencimiento	:= 'XX/XX';
			SET Var_NIP  			:= Cadena_Vacia;

			-- SE ASIGNAN VALORES
			SELECT 	TarLayDebSAFIID,		NumTarjeta,				CVV,		CONCAT(ICVV,',') AS iCVV,
					CVV2,					FechaVencimiento,		NIP
			INTO 	Var_TarLayDebSAFIID,	Var_NumTarjeta,			Var_CVV,	Var_ICVV,
					Var_CVV2,				Var_FechaVencimiento,	Var_NIP
			FROM TARLAYDEBSAFI
			WHERE EsGenerado = GeneradoNO LIMIT Entero_Cero,1;

			-- SE ASIGNA EL VALOR DEL PINBLOCK
			SET Var_PinBlock	:= Var_NIP;
			-- ASIGNACION DE Fecha Exp
			SET Var_FechaExp 	:= DATE_FORMAT(Var_FechaVigencia, '%m/%y');

			-- ASIGNACIÓN DE VALOR INDEX
			SET Var_Index := RIGHT(CONCAT(REPEAT('0',6),CAST(Var_Index AS SIGNED) +  1 ), 6);
			-- ARMADO DE CUENTA CON ESPACIO 
			SET Var_Digito1Cuenta := SUBSTRING(Var_NumTarjeta, 1, 4);
			SET Var_Digito2Cuenta := SUBSTRING(Var_NumTarjeta, 5, 4);
			SET Var_Digito3Cuenta := SUBSTRING(Var_NumTarjeta, 9, 4);
			SET Var_Digito4Cuenta := SUBSTRING(Var_NumTarjeta, 13, 4);

			SET Var_Cuenta := CONCAT(	Var_Digito1Cuenta,Espacio_Vacio,Var_Digito2Cuenta,Espacio_Vacio,Var_Digito3Cuenta,
	            							Espacio_Vacio,Var_Digito4Cuenta);
			SET Var_CVV2_Complet := CONCAT(Var_Digito4Cuenta,Espacio_Vacio,Var_CVV2);

			-- SECCIÓN TARJETAS FISICAS Y PERSONALIZADAS
			IF (Var_EsVirtual = LotTarVirtualNO) THEN
				-- SI SON TARJETAS PERSONALIZADAS, SE PROCEDE A ASIGNAR LOS NOMBRE
				IF(Var_EsPersonalizado = Personalizado)THEN
					-- LIMPIAMOS LOS CAMPOS
					SET Var_NombreTH 	:= Cadena_Vacia;
	        		SET Var_EncNombreTH	:= Cadena_Vacia;
	        		SET Var_NomPersona 	:= Cadena_Vacia;

					SELECT NomPersona
						INTO Var_NomPersona
					FROM TMP_TARLOTENOMBREPERSON LIMIT Incremental,1;

					SET Var_NombreTH 	:= REPLACE(RPAD(Var_NomPersona,21, Var_CadenaAper),Var_CadenaAper,Espacio_Vacio);
	        		SET Var_EncNombreTH	:= REPLACE(RPAD(Var_NomPersona,21, Var_CadenaAper),Var_CadenaAper,Espacio_Vacio);
				END IF;

				SET Var_PAN 		:= Var_NumTarjeta;
				
				-- ASIGNACION DE Fecha Exp
				SET Var_EncFecExp	:= DATE_FORMAT(Var_FechaVigencia, '%y%m');
				

				-- ASIGNACIÓN DE VALORES
				SET Var_VisaResCVV	:= Var_CVV;
				SET Var_LayoutTarDeb := Cadena_Vacia;

				SET Var_LayoutTarDeb := CONCAT(	Var_Index,			Var_Line1,			Var_Cuenta,			Var_Line2,			Var_FechaExp,
												Var_ICVV,			Var_Line4,			Var_NombreTH,		Var_Linea5,			Var_Empresa,
												Var_Linea6,			Var_CVV2_Complet,	Var_EncComChar,		Var_StSenTrack1,	Var_FormatCod,
												Var_PAN,			Var_SepCamp,		Var_EncNombreTH,	Var_SepCamp,		Var_EncFecExp,
												Var_ServCode,		Var_VisaReser,		Var_VisaResCVV,		Var_VisaRes2,		Var_EndSenTrack1,
												Var_StartSenTrack2,	Var_PAN,			Var_SepCamIgual,	Var_EncFecExp,		Var_ServCode,
												Var_PvvVisa,		Var_VisaResCVV,		Var_Ceros,			Var_EndSenTrack2,	Var_SepCamGuion,
												Var_SepCamPComa,	Var_25ceros,
												-- Card Carrier Information y envío --
												Var_SepCampArro,	Var_NombreClienteTbl,	Var_SepCampArro,	Var_CalleNoTbl,		Var_SepCampArro,
												Var_ColoniaTbl,		Var_SepCampArro,		Var_CiudadTbl,		Var_SepCampArro,	Var_EstadoTbl,
												Var_SepCampArro,	Var_CPTbl,				Var_SepCampArro,	Var_NumSucursalTbl,	Var_SepCampArro,
												Var_NumLoteTbl,		Var_SepCampArro,		Var_NumClienteTbl,	Var_SepCampArro,	Var_TipoTarjetaTbl,
												Var_SepCampArro,	Var_Consecutivo,		Var_SepCampArro,	Var_EsTiOAdic,		Var_SepCampArro,
												Var_RepNueReno,		Var_SepCampAper,
												-- Nuevo --
												Var_PinBlock,Var_SepCampArro
												);
			END IF;
			-- SECCIÓN TARJETAS VIRTUALES
			IF (Var_EsVirtual = LotTarVirtualSI)THEN
				SET Var_LayoutTarDeb := Cadena_Vacia;

				SET Var_LayoutTarDeb := CONCAT(Var_Index,	Var_Line1,	Var_Cuenta,	Var_Line2, Var_FechaExp, Var_ICVV,	Var_Linea5,	Var_CVV2_Complet, Var_ServiceCode,	Var_PinBlock);
			END IF;

			-- VALIDA QUE LA CADENA NO LLEGUE VACIO
			IF(IFNULL(Var_LayoutTarDeb,Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 001;
				SET Par_ErrMen := 'La cadena layout no puede ser vacía, algún valor llego nulo.';
				SET Var_Control := CAST(Var_TarLayDebSAFIID AS CHAR);
				LEAVE ManejoErrores;
			END IF;

			-- SE ASIGNA EL VALOR DE SALTO DE LINEA PARA EL FINAL DEL REGISTRO
			IF (Var_SaltoLin = Incremental)THEN
				SET Var_LayoutTarDeb := CONCAT(Var_LayoutTarDeb,"\n");
			END IF;

			-- ACTUALIZACIÓN DE LA CADENA LAYOUT
			UPDATE TARLAYDEBSAFI SET
				LayoutTarDeb = Var_LayoutTarDeb,
				EsGenerado = GeneradoSI,
				FechaActual = Var_FechaActual,
				ProgramaID =  'dateintegration.sp.GENLAYTARDEBSAFIPRO'
			WHERE TarLayDebSAFIID = Var_TarLayDebSAFIID;

			SET Incremental := Incremental + 1;
		END WHILE;
		

		-- SE REGISTRAN LA INFORMACIÓN EN LA TABLA ORIGNAL DE TARJETAS DE DEBITO
		CASE Var_TipoTarjeta 
			WHEN TipTarjetaDeb THEN
				-- ALTA EN TARJETA DE DEBITO
				INSERT INTO `TARJETADEBITO`(
			        	`TarjetaDebID`,     `LoteDebitoID`, 		`FechaRegistro`,    `FechaVencimiento`, 	`FechaActivacion`,
			        	`Estatus`,          `ClienteID`,    		`CuentaAhoID`,      `FechaBloqueo`,     	`MotivoBloqueo`,
			        	`FechaCancelacion`, `MotivoCancelacion`,	`FechaDesbloqueo`,	`MotivoDesbloqueo`,		`NIP`,
			        	`NombreTarjeta`,    `Relacion`,     		`SucursalID`,       `TipoTarjetaDebID`, 	`NoDispoDiario`,
			        	`NoDispoMes`,       `MontoDispoDiario`,		`MontoDispoMes`, 	`NoConsultaSaldoMes`,	`NoCompraDiario`,
			        	`NoCompraMes`,      `MontoCompraDiario`,	`MontoCompraMes`,	`PagoComAnual`,    		`FPagoComAnual`,
			        	`TipoCobro`,        `EsVirtual`,			`EmpresaID`,    	`Usuario`,          	`FechaActual`,
			        	`DireccionIP`,		`ProgramaID`,       	`Sucursal`,     	`NumTransaccion`)
				SELECT 	NumTarjeta,			LoteDebSAFIID,			FechaRegistro,		FechaVencimiento,		Fecha_Vacia,
						Estatus_Creada,		Entero_Cero,        	Entero_Cero,        Fecha_Vacia,        	Entero_Cero,
						Fecha_Vacia,    	Entero_Cero,        	Fecha_Vacia,        Entero_Cero,        	NIP,
						Cadena_Vacia,		Cadena_Vacia,			Sucursal,			Var_TipoTarjetaDebID,	Entero_Cero,
						Entero_Cero,    	Decimal_Cero,       	Decimal_Cero,       Entero_Cero,        	Entero_Cero,
						Entero_Cero,    	Decimal_Cero,       	Decimal_Cero,       Cadena_Vacia,       	Fecha_Vacia,
						Cadena_Vacia,   	Var_EsVirtual,			EmpresaID,      	Usuario,	        	FechaActual,
						DireccionIP,		ProgramaID, 			Sucursal,       	NumTransaccion
				FROM TARLAYDEBSAFI
					WHERE LoteDebSAFIID = Var_LoteDebSAFIID;

				-- REGISTRO EN BITACORA DEBITO
				INSERT INTO `BITACORATARDEB`(
			        	`TarjetaDebID`,		`TipoEvenTDID`,		`MotivoBloqID`,	`DescripAdicio`,	`Fecha`,
			        	`NombreCliente`,	`EmpresaID`,		`Usuario`,		`FechaActual`,		`DireccionIP`,
			        	`ProgramaID`,		`Sucursal`,			`NumTransaccion`)
			    SELECT 	NumTarjeta,			Estatus_Creada,		NULL,			DescripTar,			FechaRegistro,
			    		Cadena_Vacia,		EmpresaID,      	Usuario,	    FechaActual,		DireccionIP,		
						ProgramaID, 		Sucursal,       	NumTransaccion
				FROM TARLAYDEBSAFI
					WHERE LoteDebSAFIID = Var_LoteDebSAFIID;

			WHEN TipTarjetaCred THEN
				-- ALTA EN TARJETA DE CREDITO
				INSERT INTO `TARJETACREDITO`(
			        `TarjetaCredID`,     `LoteCreditoID`, `FechaRegistro`,    `FechaVencimiento`, `FechaActivacion`,
			        `Estatus`,          `ClienteID`,    `LineaTarCredID`,      `FechaBloqueo`,     `MotivoBloqueo`,
			        `FechaCancelacion`, `MotivoCancelacion`,`FechaDesbloqueo`,`MotivoDesbloqueo`,`NIP`,
			        `NombreTarjeta`,    `Relacion`,     `SucursalID`,       `TipoTarjetaCredID`, `NoDispoDiario`,
			        `NoDispoMes`,       `MontoDispoDiario`,`MontoDispoMes`, `NoConsultaSaldoMes`,`NoCompraDiario`,
			        `NoCompraMes`,      `MontoCompraDiario`,`MontoCompraMes`,`PagoComAnual`,    `FPagoComAnual`,
			        `TipoCobro`,        `EsVirtual`,	`EmpresaID`,    `Usuario`,          `FechaActual`,      `DireccionIP`,
			        `ProgramaID`,       `Sucursal`,     `NumTransaccion`)
			    SELECT 	
			    	NumTarjeta,			LoteDebSAFIID,			FechaRegistro,		FechaVencimiento,		Fecha_Vacia,
					Estatus_Creada,		Entero_Cero,        	Entero_Cero,        Fecha_Vacia,        	Entero_Cero,
					Fecha_Vacia,    	Entero_Cero,        	Fecha_Vacia,        Entero_Cero,        	NIP,
					Cadena_Vacia,		Cadena_Vacia,			Sucursal,			Var_TipoTarjetaDebID,	Entero_Cero,
					Entero_Cero,    	Decimal_Cero,       	Decimal_Cero,       Entero_Cero,        	Entero_Cero,
					Entero_Cero,    	Decimal_Cero,       	Decimal_Cero,       Cadena_Vacia,       	Fecha_Vacia,
					Cadena_Vacia,   	Var_EsVirtual,			EmpresaID,      	Usuario,	        	FechaActual,
					DireccionIP,		ProgramaID, 			Sucursal,       	NumTransaccion
				FROM TARLAYDEBSAFI
					WHERE LoteDebSAFIID = Var_LoteDebSAFIID;

				-- REGISTRO EN BITACORA CREDITO
				INSERT INTO `BITACORATARCRED`(
			        	`TarjetaCredID`,	`TipoEvenTDID`,		`MotivoBloqID`,	`DescripAdicio`,	`Fecha`,
			        	`NombreCliente`,	`EmpresaID`,		`Usuario`,		`FechaActual`,		`DireccionIP`,
			        	`ProgramaID`,		`Sucursal`,			`NumTransaccion`)
			    SELECT 	NumTarjeta,			Estatus_Creada,		NULL,			DescripTar,			FechaRegistro,
			    		Cadena_Vacia,		EmpresaID,      	Usuario,	    FechaActual,		DireccionIP,		
						ProgramaID, 		Sucursal,       	NumTransaccion
				FROM TARLAYDEBSAFI
					WHERE LoteDebSAFIID = Var_LoteDebSAFIID;

		END CASE;

		SET Par_NumErr      := 0;
		SET Par_ErrMen      := 'Lote de tarjetas generado con exito.';
		SET Par_Consecutivo := 0;
		SET Var_Control		:= 'tarLayDebSAFIID';

	END ManejoErrores;
-- SI LA SALIDA ES SI DEVUELVE EL MENSAJE DE EXITO
IF (SalidaSI = SalidaSI) THEN
    SELECT	Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control	AS Control,
			Par_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$
