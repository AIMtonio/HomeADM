-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ALGORITREFPAGOCAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `ALGORITREFPAGOCAL`;
DELIMITER $$


CREATE PROCEDURE `ALGORITREFPAGOCAL`(
# =====================================================================================
# ------- STORED PARA CALCULAR LA REFERENCIA DE PAGO POR INSTITUCION ---------
# =====================================================================================
    Par_InstitucionID 		INT(11),		-- ID de la institucion
	Par_Referencia			VARCHAR(50),	-- Referencia
    INOUT Par_NuevaRefe		VARCHAR(50),	-- Nueva Referencia

    Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400)	-- Parametro de salida mensaje de error
)

TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES

    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
    DECLARE Var_GeneraRefeDep	CHAR(1);			-- S= si genera referencia, N= no genera
    DECLARE Var_AlgoritmoID		INT(11);			-- ID del algoritmo que utiliza la institucion
    DECLARE Var_NombreCorto		VARCHAR(45);		-- Nombre Corto de la institucion
    DECLARE Var_Llamada 		VARCHAR(800);		-- Almacena la llamada a realizar el proceso
    DECLARE Var_ProcesoAlgoritmo VARCHAR(100);		-- Nombre del procedimiento

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno

    -- ASIGNACIŃ DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
							  concretar la operacion.Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-ALGORITREFPAGOCAL');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		IF NOT EXISTS(SELECT InstitucionID FROM INSTITUCIONES WHERE InstitucionID=Par_InstitucionID) THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'El Institucion no Existe.';
			SET Var_Control		:= 'institucionID';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Referencia, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'La Referencia esta Vacia';
			SET Var_Control		:= 'referencia';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        -- OBTIENE LOS DATOS DE LA INSTITUCION
        SELECT NombreCorto,GeneraRefeDep, AlgoritmoID
			INTO Var_NombreCorto, Var_GeneraRefeDep, Var_AlgoritmoID
		FROM INSTITUCIONES
        WHERE InstitucionID = Par_InstitucionID;

        SET Var_NombreCorto := IFNULL(Var_NombreCorto,Cadena_Vacia);
        SET Var_GeneraRefeDep := IFNULL(Var_GeneraRefeDep,Cadena_Vacia);
        SET Var_AlgoritmoID := IFNULL(Var_AlgoritmoID,Entero_Cero);

        IF(Var_GeneraRefeDep = Cadena_Vacia)THEN
			SET Par_NumErr 		:= 3;
			SET Par_ErrMen 		:= CONCAT('La institucion ',Var_NombreCorto,' no esta parametrizada');
			SET Var_Control		:= 'institucionID';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
        END IF;

        IF(Var_GeneraRefeDep = 'N')THEN
			SET Par_NumErr 		:= 4;
			SET Par_ErrMen 		:= CONCAT('La institucion ',Var_NombreCorto,' esta parametrizada para NO generar Referencias');
			SET Var_Control		:= 'institucionID';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
        END IF;

        IF(Var_AlgoritmoID = Entero_Cero)THEN
			SET Par_NumErr 		:= 5;
			SET Par_ErrMen 		:= CONCAT('La institucion ',Var_NombreCorto,' no tiene parametrizado el algoritmo para generar Referencias');
			SET Var_Control		:= 'institucionID';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
        END IF;

        -- OBTIENE NOMBRE DEL PROCEDIMIENTO DE LA INSTITUCION PARA GENERAR REFERENCIA
        SET Var_ProcesoAlgoritmo :=(SELECT Procedimiento FROM ALGORITMODEPREF WHERE AlgoritmoID = Var_AlgoritmoID);
        SET Var_ProcesoAlgoritmo := IFNULL(Var_ProcesoAlgoritmo,Cadena_Vacia);

        IF(Var_ProcesoAlgoritmo = Cadena_Vacia)THEN
			SET Par_NumErr 		:= 6;
			SET Par_ErrMen 		:= CONCAT('La institucion ',Var_NombreCorto,' no tiene definido un Procedimiento para generar referencia');
			SET Var_Control		:= 'institucionID';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
        END IF;

        CASE Var_ProcesoAlgoritmo
			WHEN 'ALGBANCOMER35CAL' THEN
				CALL ALGBANCOMER35CAL(
					Par_InstitucionID,Par_Referencia,Par_NuevaRefe,Salida_NO,Par_NumErr,Par_ErrMen);

                IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			WHEN 'ALGBANCOMER14CAL' THEN
				CALL ALGBANCOMER14CAL(
					Par_InstitucionID,Par_Referencia,Par_NuevaRefe,Salida_NO,Par_NumErr,Par_ErrMen);

                IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			WHEN 'ALGORITMOOXXOCAL' THEN
				CALL ALGORITMOOXXOCAL(
					Par_InstitucionID,Par_Referencia,Par_NuevaRefe,Salida_NO,Par_NumErr,Par_ErrMen);

                IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			WHEN 'ALGORITMOBANSEFICAL' THEN
				CALL ALGORITMOBANSEFICAL(
					Par_InstitucionID,Par_Referencia,Par_NuevaRefe,Salida_NO,Par_NumErr,Par_ErrMen);

                IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			WHEN 'ALGBANCOMER36CAL' THEN
				CALL ALGBANCOMER36CAL(
					Par_InstitucionID, 	Par_Referencia, Par_NuevaRefe, Salida_NO, Par_NumErr, Par_ErrMen);

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
		END CASE;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= Par_NuevaRefe;
		SET Var_Control		:= 'referencia';
		SET Var_Consecutivo	:= Par_NuevaRefe;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$
