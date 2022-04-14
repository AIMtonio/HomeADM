DELIMITER ;
DROP PROCEDURE IF EXISTS `RELACIONADOSFISCALESALT`;
DELIMITER $$

CREATE PROCEDURE `RELACIONADOSFISCALESALT`(
# =====================================================================================
# ------- STORED PARA ALTA DE RELACIONADOS FISCALES  ---------
# =====================================================================================
	Par_ClienteID			INT(11),		-- ID del cliente tabla CLIENTES
	Par_ParticipaFiscalCte	DECIMAL(14,2),	-- Indica el % que corresponde a la participacion fiscal del cliente puede ser un valor a dos decimales en un rango del 0 al 100
	Par_Ejercicio			INT(11),		-- Anio del ejercicio
	Par_TipoRelacionado		CHAR(1),		-- Tipo relacionado: C= es un cliente tabla CLIENTES, R = es un relacionado fiscal tabla RELACIONADOSFICALES
	Par_CteRelacionadoID	INT(11),		-- Idetinficador del relacionado id de cliente o 0 si es relacionado fiscal

    Par_ParticipacionFiscal	DECIMAL(14,2),	-- Indica el % que corresponde a la participacion fiscal del relacionado puede ser un valor a dos decimales en un rango del 0 al 100
    Par_TipoPersona			CHAR(1),		-- Tipo de Personalidad: F.- Persona Fisica Sin Actividad Empresarial, A.- Persona Fisica Con Actividad Empresarial
	Par_PrimerNombre		VARCHAR(50),	-- Primer Nombre
	Par_SegundoNombre		VARCHAR(50),	-- Segundo Nombre
	Par_TercerNombre		VARCHAR(50),	-- Tercer Nombre

    Par_ApellidoPaterno		VARCHAR(50),	-- Apellido Paterno
    Par_ApellidoMaterno		VARCHAR(50),	-- Apellido Materno
	Par_RegistroHacienda	CHAR(1),		-- Registro alta en hacienda S= si, N= no
	Par_Nacion				CHAR(1),		-- Nacionalidad N = Nacional, E = Extranjero
	Par_PaisResidencia		INT(5),			-- Pais de residencia, llave foranea a PAISES

	Par_RFC					CHAR(13),		-- Registro Federal de Contribuyentes
	Par_CURP				CHAR(18),		-- Clave Unica de Registro Poblacional
	Par_EstadoID			INT(11),		-- Hace referencia al ID del estado del cliente
	Par_MunicipioID			INT(11),		-- Hace referencia al ID del muncipio del cliente
	Par_LocalidadID			INT(11),		-- Numero de Localidad Correspondiente al Municipio

	Par_ColoniaID			INT(11),		-- iD de la colonia
    Par_Calle				VARCHAR(50),	-- Nombre de la calle
	Par_NumeroCasa			CHAR(10),		-- Numero de casa
	Par_NumInterior			CHAR(10),		-- Numero interior de la casa.
	Par_Piso				CHAR(50),		-- Número de piso.

	Par_CP					CHAR(5),		-- Codigo Postal
    Par_Lote				CHAR(50),		-- Lote
	Par_Manzana				CHAR(50),		-- Manzana
	Par_DireccionCompleta	VARCHAR(500),	-- Este campo se arma con los campos calle, numero, colonia, y CP.

    Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES

    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
    DECLARE Var_FechaSistema	DATE;
	DECLARE Var_RelacionadoFiscalID INT(11);
    DECLARE Var_ClienteID		INT(11);

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Cons_NO   	    	CHAR(1);      		-- Constante NO
    DECLARE Est_Pendiente		CHAR(1);			-- Estatus: Pendiente

    -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Cons_NO		          	:= 'N';
    SET Est_Pendiente			:= 'P';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-RELACIONADOSFISCALESALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		IF(Par_ClienteID = Entero_Cero)THEN

			SELECT ClienteID
				INTO Var_ClienteID
			FROM CLIENTES
			WHERE RFC = Par_RFC;

            SET Var_ClienteID := IFNULL(Var_ClienteID,Entero_Cero);

            IF(Var_ClienteID > Entero_Cero)THEN
				SET Par_NumErr 		:= 1;
				SET Par_ErrMen 		:= CONCAT('EL RFC ', Par_RFC, ' esta registrado a el aportante ',Var_ClienteID,'.');
				SET Var_Control		:= 'fechaAdquisicion';
				SET Var_Consecutivo	:= Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

        END IF;

        SET Var_RelacionadoFiscalID := (SELECT IFNULL(MAX(RelacionadoFiscalID),Entero_Cero) + Entero_Uno FROM RELACIONADOSFISCALES);
		SET Aud_FechaActual := NOW();

        INSERT INTO RELACIONADOSFISCALES(
			RelacionadoFiscalID,	ClienteID, 				ParticipaFiscalCte,		Ejercicio,					TipoRelacionado,
			CteRelacionadoID,		ParticipacionFiscal,	TipoPersona,			PrimerNombre,				SegundoNombre,
            TercerNombre,			ApellidoPaterno,		ApellidoMaterno,		RegistroHacienda,			Nacion,
            PaisResidencia,			RFC,					CURP,					EstadoID,					MunicipioID,
            LocalidadID,			ColoniaID,				Calle,					NumeroCasa,					NumInterior,
            Piso,					CP,						Lote,					Manzana,					DireccionCompleta,
            Estatus,				EmpresaID, 				Usuario, 				FechaActual, 				DireccionIP,
            ProgramaID, 			Sucursal, 				NumTransaccion
        )VALUES(
			Var_RelacionadoFiscalID,Par_ClienteID,			Par_ParticipaFiscalCte,	Par_Ejercicio,				Par_TipoRelacionado,
			Par_CteRelacionadoID,	Par_ParticipacionFiscal,Par_TipoPersona,		Par_PrimerNombre,			Par_SegundoNombre,
            Par_TercerNombre,		Par_ApellidoPaterno,	Par_ApellidoMaterno,	Par_RegistroHacienda,		Par_Nacion,
            Par_PaisResidencia,		Par_RFC,				Par_CURP,				Par_EstadoID,				Par_MunicipioID,
            Par_LocalidadID,		Par_ColoniaID,			Par_Calle,				Par_NumeroCasa,				Par_NumInterior,
            Par_Piso,				Par_CP,					Par_Lote,				Par_Manzana,				Par_DireccionCompleta,
            Est_Pendiente,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,
            Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
        );

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Relacionado Fiscal Agregado Exitosamente:',CAST(Var_RelacionadoFiscalID AS CHAR) );
		SET Var_Control		:= 'relacionadoFiscalID';
		SET Var_Consecutivo	:= Var_RelacionadoFiscalID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$