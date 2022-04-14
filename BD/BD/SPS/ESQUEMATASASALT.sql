-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMATASASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMATASASALT`;
DELIMITER $$

CREATE PROCEDURE `ESQUEMATASASALT`(
# =====================================================================================
# ------- STORED PARA ALTA ESQUEMA DE TASAS POR PRODUCTO DE CREDITO Y SUCURSAL---------
# =====================================================================================
	Par_SucursalID 			INT(11),			-- Numero de sucursal
	Par_ProdCreID 			INT(11),			-- Producto de credito
	Par_MinCredito			INT(11),			-- Minimo de creditos
	Par_MaxCredito			INT(11),			-- Maximo de creditos
	Par_Califi				VARCHAR(45),		-- Calificacion del cliente

	Par_MontoInf			DECIMAL(12,2),		-- Monto Inferior
	Par_MontoSup			DECIMAL(12,2),		-- Monto Superior
	Par_TasaFija			DECIMAL(12,4),		-- Tasa Fija
	Par_SobreTasa			DECIMAL(12,4),		-- Sobre Tasa
	Par_PlazoID				VARCHAR(20),	    -- ID del plazo del producto, DEFAULT es "T"=TODOS, tabla CREDITOSPLAZOS.

	Par_InstitNominaID		INT(11),			-- Numero de institucion de nomina obligatorio para productos de nomina
	Par_NivelID				INT(11),			-- Valor que el analista de credito asigna en el registro, DEFAULT 0=TODA, hace referecia a una tabla

    Par_Salida    			CHAR(1), 			-- Parametro de salida S= si, N= no
    INOUT	Par_NumErr 		INT(11),			-- Parametro de salida numero de error
    INOUT	Par_ErrMen  	VARCHAR(400),		-- Parametro de salida mensaje de error

    /* Parametros de Auditoria */
    Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia				CHAR(1);
	DECLARE	Entero_Cero					INT;
	DECLARE	Float_Cero					FLOAT;
	DECLARE	Decimal_Cero				DECIMAL(12,2);
	DECLARE	SalidaSI					CHAR(1);
	DECLARE	SalidaNO					CHAR(1);
	DECLARE PlazoTodos					VARCHAR(20);
	DECLARE	TasaFijaID					INT(11);
	DECLARE Estatus_Inactivo			CHAR(1);	-- Estatus Inactivo

	-- Declaracion de Variables
	DECLARE	Var_MonMin					DECIMAL(12,2);
	DECLARE	Var_MonMax					DECIMAL(12,2);
	DECLARE	Var_MinCredito				INT(11);
	DECLARE	Var_MaxCredito				INT(11);
	DECLARE	Var_MontoInf				DECIMAL(12,2);
	DECLARE	Var_MontoSup				DECIMAL(12,2);
	DECLARE	Var_MinCred					INT(11);
	DECLARE Var_Cali					CHAR(1);
	DECLARE Var_Calificacion			CHAR(100);
	DECLARE Var_Plazo					VARCHAR(20);
	DECLARE Var_DelTodos				INT(11);
	DECLARE	Var_Registros				INT(11);
	DECLARE	Var_CalcInteres				INT(11);
	DECLARE	Var_InstitNominaID			INT(11);
	DECLARE	Var_DescripcionIntNomina	VARCHAR(200);
	DECLARE	Var_TasaFija				DECIMAL(12,4);
	DECLARE	Var_MontoInferior			DECIMAL(12,2);
	DECLARE Var_Control 				VARCHAR(50);
	DECLARE Var_Consecutivo				VARCHAR(50);
    DECLARE Var_NivelID					INT(11);
    DECLARE Var_Estatus					CHAR(2);		-- Almacena el estatus del producto de credito
	DECLARE Var_Descripcion				VARCHAR(100);	-- Almacena la descripcion del producto de credito


	-- Declaracion del CURSOR para validar el esquema de tasas
	DECLARE CURSORVALIDAESQ CURSOR FOR
		SELECT IFNULL(MinCredito,Entero_Cero),	IFNULL(MaxCredito,Entero_Cero),	IFNULL(MontoInferior,Decimal_Cero), IFNULL(MontoSuperior,Decimal_Cero),Calificacion,
				PlazoID,						InstitNominaID, TasaFija, NivelID
			FROM 	ESQUEMATASAS
			WHERE 	SucursalID			= 	Par_SucursalID
			AND 	ProductoCreditoID	= 	Par_ProdCreID
			AND 	Calificacion		=	Par_Califi
			AND 	((Par_MontoInf BETWEEN MontoInferior  AND MontoSuperior ) OR (Par_MontoSup  BETWEEN MontoInferior AND MontoSuperior ))
			AND 	(PlazoID =	Par_PlazoID OR PlazoID=PlazoTodos);


	-- Asignacion  de constantes
	SET	Cadena_Vacia	:= '';
	SET	Entero_Cero		:= 0;
	SET	Float_Cero		:= 0.0;
	SET	Decimal_Cero	:= 0.0;
	SET	SalidaSI		:= 'S';

	SET	SalidaNO		:= 'N';
	SET PlazoTodos		:= 'T';
	SET TasaFijaID		:= 1;
	SET Estatus_Inactivo	:= 'I';		 -- Estatus Inactivo

	SET Aud_FechaActual := NOW();

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ESQUEMATASASALT');
				SET Var_Control = 'SQLEXCEPTION';
		END;

		SELECT IFNULL(MontoSuperior,Decimal_Cero) INTO Var_MontoInferior
		FROM ESQUEMATASAS
			WHERE SucursalID		= Par_SucursalID
			AND ProductoCreditoID	= Par_ProdCreID
			AND Calificacion		= Par_Califi
			AND MontoSuperior 		= Par_MontoInf
			AND  	PlazoID				= Par_PlazoID
			LIMIT 1;


		SET Par_InstitNominaID := IFNULL(Par_InstitNominaID,Entero_Cero);

		IF IFNULL(Par_SucursalID, Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'La Sucursal esta Vacia';
			SET Var_Control		:= 'sucursalID';
			SET Var_Consecutivo	:= Par_SucursalID;
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_ProdCreID, Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'El Producto de Credito esta Vacio.';
			SET Var_Control		:= 'productoCreditoID';
			SET Var_Consecutivo	:= Par_ProdCreID;
			LEAVE ManejoErrores;
		END IF;


		IF IFNULL(Par_MinCredito, Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr 		:= 3;
			SET Par_ErrMen 		:= 'El Minimo de Creditos esta Vacio.';
			SET Var_Control		:= 'minCredito';
			SET Var_Consecutivo	:= Par_MinCredito;
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_MaxCredito, Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr 		:= 4;
			SET Par_ErrMen 		:= 'El Maximo de Creditos esta Vacio.';
			SET Var_Control		:= 'maxCredito';
			SET Var_Consecutivo	:= Par_MaxCredito;
			LEAVE ManejoErrores;
		END IF;


		IF IFNULL(Par_Califi, Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr 		:= 5;
			SET Par_ErrMen 		:= 'La Calificacion esta Vacia.';
			SET Var_Control		:= 'calificacion';
			SET Var_Consecutivo	:= Par_Califi;
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_MontoInf, Decimal_Cero) < Var_MonMin ) THEN
			SET Par_NumErr 		:= 6;
			SET Par_ErrMen 		:= CONCAT('El Monto Inferior no Debe ser Menor a: ',CONVERT(Var_MonMin,CHAR(20)));
			SET Var_Control		:= 'montoInferior';
			SET Var_Consecutivo	:= Par_MontoInf;
			LEAVE ManejoErrores;
		END IF;


		IF (IFNULL(Par_MontoInf, Decimal_Cero) > Var_MonMax ) THEN
			SET Par_NumErr 		:= 7;
			SET Par_ErrMen 		:= 'El Monto Inferior no Debe ser Mayor al Superior';
			SET Var_Control		:= 'montoInferior';
			SET Var_Consecutivo	:= Par_MontoInf;
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_MontoSup, Entero_Cero) > Var_MonMax ) THEN
			SET Par_NumErr 		:= 8;
			SET Par_ErrMen 		:= CONCAT('El monto Superior no Debe ser Mayor a: ',CONVERT(Var_MonMax,CHAR(20)));
			SET Var_Control		:= 'montoSuperior';
			SET Var_Consecutivo	:= Par_MontoSup;
			LEAVE ManejoErrores;
		END IF;

		SELECT CalcInteres INTO Var_CalcInteres
			FROM PRODUCTOSCREDITO
				WHERE ProducCreditoID=IFNULL(Par_ProdCreID, Entero_Cero);

		/* Se valida que la tasa fija no venga vacia cuando el producto de credito
		 * hace el calculo de intereses por tasa fija
		 * */
		IF(((IFNULL(Par_TasaFija,Decimal_Cero))=Decimal_Cero) AND IFNULL(Var_CalcInteres,Entero_Cero)=TasaFijaID)THEN
			SET Par_NumErr 		:= 9;
			SET Par_ErrMen 		:= 'La Tasa Fija esta Vacia.';
			SET Var_Control		:= 'tasaFija';
			SET Var_Consecutivo	:= Par_TasaFija;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_MontoInf = Var_MontoInferior)THEN
			SET Par_NumErr 		:= 10;
			SET Par_ErrMen 		:= CONCAT("El Monto Inferior Debe ser Mayor a $ ",Par_MontoInf,", ya Existe un Monto Superior por $ ",Par_MontoInf);
			SET Var_Control		:= 'montoInferior';
			SET Var_Consecutivo	:= Par_MontoInf;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NivelID > Entero_Cero)THEN
			IF NOT EXISTS (SELECT NivelID FROM NIVELCREDITO WHERE NivelID = Par_NivelID)THEN
				SET Par_NumErr 		:= 14;
				SET Par_ErrMen 		:= "El Nivel no Existe.";
				SET Var_Control		:= 'nivelID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_PlazoID = PlazoTodos) THEN
			IF EXISTS (SELECT MontoSuperior FROM ESQUEMATASAS
						WHERE 	SucursalID		= 	Par_SucursalID
						AND 	ProductoCreditoID	= 	Par_ProdCreID
						AND 	Calificacion		=	Par_Califi
						AND 	PlazoID				=  PlazoTodos
                        AND 	NivelID				= 	Par_NivelID
						AND (((MontoInferior >= Par_MontoInf AND MontoInferior <= Par_MontoSup
                        AND MinCredito >= Par_MinCredito AND MaxCredito <= Par_MaxCredito)
							OR (MontoSuperior >= Par_MontoInf AND MontoSuperior <= Par_MontoSup
                             AND MinCredito >= Par_MinCredito AND MaxCredito <= Par_MaxCredito)))
						LIMIT 1) THEN
				SET Par_NumErr 		:= 15;
				SET Par_ErrMen      := 'El Monto Inferior y Monto Superior ya se Encuentra Dentro de Otro Rango';
				SET Var_Control		:= 'minCredito';
				SET Var_Consecutivo	:= Par_MinCredito;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SELECT 	Estatus,		Descripcion
		INTO 	Var_Estatus,	Var_Descripcion
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID = Par_ProdCreID;

		IF(Var_Estatus = Estatus_Inactivo) THEN
			SET Par_NumErr 	:= 16;
			SET Par_ErrMen 	:= CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
			SET Var_Control	:= 'productoCreditoID';
			LEAVE ManejoErrores;
		END IF;

		OPEN CURSORVALIDAESQ;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP

			FETCH CURSORVALIDAESQ INTO
				Var_MinCredito,	Var_MaxCredito,	Var_MonMin,	Var_MonMax,Var_Cali,Var_Plazo, Var_InstitNominaID,
				Var_TasaFija,Var_NivelID;

				BEGIN
					IF((Par_MinCredito BETWEEN Var_MinCredito AND Var_MaxCredito) AND
						(Par_MaxCredito BETWEEN Var_MinCredito AND Var_MaxCredito) AND (Par_Califi=Var_Cali)
						AND Par_PlazoID=Var_Plazo AND Par_InstitNominaID = Var_InstitNominaID
                        AND Par_NivelID = Var_NivelID) THEN

						CASE Var_Cali	WHEN 'N' THEN SET Var_Calificacion:='NO ASIGNADA';
										WHEN 'A' THEN SET Var_Calificacion:='EXCELENTE';
										WHEN 'B' THEN SET Var_Calificacion:='BUENA';
										WHEN 'C' THEN SET Var_Calificacion:='REGULAR';
						END CASE;

						SET Par_NumErr 		:= 12;
						SET Var_DescripcionIntNomina := (SELECT IFNULL(NombreInstit,'') FROM INSTITNOMINA
															WHERE InstitNominaID = Var_InstitNominaID LIMIT 1);
						SET Var_DescripcionIntNomina := IFNULL(Var_DescripcionIntNomina, Cadena_Vacia);

						IF(Var_InstitNominaID>Entero_Cero) THEN
							SET Par_ErrMen 		:= CONCAT(
								'El Esquema Esta Dentro del Rango Minimo ',CONVERT(Var_MinCredito,CHAR(30)),
								' y Maximo ',CONVERT(Var_MaxCredito,CHAR(30)),
								' Con Monto Inferior ',CONVERT(Var_MonMin,CHAR(30)),
								' y Monto Superior ',CONVERT(Var_MonMax,CHAR(30)),
								' , una Calificacion ',Var_Calificacion,
								' y con la Empresa de Nomina ', Var_DescripcionIntNomina,".");
						ELSE
							SET Par_ErrMen 		:= CONCAT('El Esquema Esta Dentro del Rango Minimo ',CONVERT(Var_MinCredito,CHAR(30)),' y Maximo ',CONVERT(Var_MaxCredito,CHAR(30)),
											   ' Con Monto Inferior ',CONVERT(Var_MonMin,CHAR(30)),' y Monto Superior ',CONVERT(Var_MonMax,CHAR(30)),' y una Calificacion ',Var_Calificacion);
						END IF;

						SET Var_Control		:= 'minCredito';
						SET Var_Consecutivo	:= Par_MinCredito;
						LEAVE ManejoErrores;
					END IF;
				END;
			END LOOP;
		END;
		CLOSE CURSORVALIDAESQ;

		SELECT SucursalID INTO Var_DelTodos
				FROM ESQUEMATASAS
						WHERE  SucursalID 			= Par_SucursalID
						AND	   ProductoCreditoID 	= Par_ProdCreID
						AND    MinCredito			= Par_MinCredito
						AND    MaxCredito			= Par_MaxCredito
						AND    Calificacion			= Par_Califi
						AND    MontoInferior		= Par_MontoInf
						AND    MontoSuperior		= Par_MontoSup
						AND	   PlazoID			   != PlazoTodos
						AND    InstitNominaID 		= Par_InstitNominaID
						LIMIT 1;

		IF(IFNULL(Var_DelTodos,Entero_Cero)>Entero_Cero) THEN
			IF(Par_PlazoID=PlazoTodos) THEN
				DELETE
					FROM ESQUEMATASAS
						WHERE  SucursalID 			= Par_SucursalID
						AND	   ProductoCreditoID 	= Par_ProdCreID
						AND    MinCredito			= Par_MinCredito
						AND    MaxCredito			= Par_MaxCredito
						AND    Calificacion			= Par_Califi
						AND    MontoInferior		= Par_MontoInf
						AND    MontoSuperior		= Par_MontoSup
						AND    InstitNominaID 		= Par_InstitNominaID
						AND    PlazoID			   != PlazoTodos;

			END IF;
		ELSE
			SELECT SucursalID INTO Var_DelTodos
				FROM ESQUEMATASAS
						WHERE  SucursalID 			= Par_SucursalID
						AND	   ProductoCreditoID 	= Par_ProdCreID
						AND    MinCredito			= Par_MinCredito
						AND    MaxCredito			= Par_MaxCredito
						AND    Calificacion			= Par_Califi
						AND    MontoInferior		= Par_MontoInf
						AND    MontoSuperior		= Par_MontoSup
						AND	   PlazoID			    = PlazoTodos
						AND    InstitNominaID 		= Par_InstitNominaID
                        AND    NivelID				= Par_NivelID
						LIMIT 1;

			IF(IFNULL(Var_DelTodos,Entero_Cero)>Entero_Cero) THEN
				SET Par_NumErr := 13;
				SET Par_ErrMen := 'Esquema de Tasa ya se encuentra dentro de otro Rango ';
				SET Var_Control:= 'sucursalID';
				SET Var_Consecutivo:= Par_SucursalID;
				LEAVE ManejoErrores;
			END IF;

		END IF;

		INSERT ESQUEMATASAS (
			SucursalID, 		ProductoCreditoID,	MinCredito,			MaxCredito,			Calificacion,
			MontoInferior, 		MontoSuperior,		TasaFija,			SobreTasa,			PlazoID,
			InstitNominaID,		NivelID,
            Empresa, 			Usuario,			FechaActual,		DireccionIP,		ProgramaID,
            Sucursal,			NumTransaccion)
		VALUES (
			Par_SucursalID,		Par_ProdCreID,		Par_MinCredito,		Par_MaxCredito,		Par_Califi,
			Par_MontoInf,		Par_MontoSup,		Par_TasaFija, 		Par_SobreTasa,		Par_PlazoID,
			Par_InstitNominaID,	Par_NivelID,
            Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
            Aud_Sucursal,		Aud_NumTransaccion);


		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Esquema de Tasa Agregado Exitosamente.';
		SET Var_Control:= 'sucursalID';
		SET Var_Consecutivo:= Par_SucursalID;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$