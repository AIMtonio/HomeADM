-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBCEDESCONWSVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBCEDESCONWSVAL`;DELIMITER $$

CREATE PROCEDURE `CRCBCEDESCONWSVAL`(
	/*SP para Validacion de consultas de cedes para WS Crediclub*/
	Par_CedeID				INT(11),			-- ID de cede
    Par_NumValida			INT(11),			--
	/* Parametros de Auditoria */
    Par_Salida				CHAR(1),			-- Salida S:Si No:No
	INOUT Par_NumErr		INT(11),			-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de error

	Par_EmpresaID			INT(11),			-- Auditoria
	Aud_Usuario				INT(11),			-- Auditoria
	Aud_FechaActual			DATETIME,			-- Auditoria

	Aud_DireccionIP			VARCHAR(15),		-- Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Auditoria
	Aud_Sucursal			INT(11),			-- Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Auditoria
)
TerminaStore: BEGIN
    -- Declaracion variables
    DECLARE Var_Control			VARCHAR(50);		-- Nombre del campo
    DECLARE Var_Estatus			CHAR(1);			-- Estatus del credito
    DECLARE Var_EstatusCli		CHAR(1);			-- Estatus del cliente
    DECLARE Var_CedeID			INT(11);			-- Idetificador del cliente
	DECLARE Var_EjecutaCierre	CHAR(1);			-- indica si se esta realizando el cierre de dia

    -- Declaracion de constantes
    DECLARE Entero_Cero			INT(11);
    DECLARE Cadena_Vacia		CHAR(1);
    DECLARE Est_Vigente			CHAR(1);
    DECLARE Est_Registrada		CHAR(1);
    DECLARE ConsultaAmortiza 	INT(11);
    DECLARE ConsultaCede		INT(11);
    DECLARE Salida_SI 			CHAR(1);
    DECLARE ValorCierre			VARCHAR(30);

    -- Asignacion de constantes
    SET Entero_Cero  		:= 0;		-- entero vacio
    SET Cadena_Vacia 		:= '';		-- cadena vacia
    SET Est_Vigente			:= 'N';		-- estatus vigente
    SET Est_Registrada		:= 'A';
    SET ConsultaAmortiza 	:= 1; 		-- Consulta amortizaciones
    SET ConsultaCede		:= 2;		-- COnsulta de cedes
    SET Salida_SI 			:= 'S'; 	-- Indica si se realiza la salida de datos
	SET ValorCierre			:= 'EjecucionCierreDia'; -- INDICA SI SE REALIZA EL CIERRE DE DIA.


    ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRCBCEDESCONWSVAL');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		SET Var_EjecutaCierre := (SELECT  ValorParametro  FROM PARAMGENERALES WHERE LlaveParametro = ValorCierre);

		-- Validamos que no se este ejecutando el cierre de dia
		IF(IFNULL(Var_EjecutaCierre,Cadena_Vacia)=Salida_SI)THEN
			SET Par_NumErr  := 800;
			SET Par_ErrMen  := CONCAT('El Cierre de Dia Esta en Ejecucion, Espere un Momento Por favor.');
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_CedeID,Entero_Cero)=Entero_Cero) THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'El Numero de CEDE Esta Vacio';
			SET Var_Control 	:= 'creditoID' ;
			LEAVE ManejoErrores;
        END IF;

        SELECT CedeID, Estatus INTO Var_CedeID, Var_Estatus
			FROM CEDES WHERE CedeID= Par_CedeID;

		SET Var_Estatus := IFNULL(Var_Estatus,Cadena_Vacia);

        IF(IFNULL(Var_CedeID,Entero_Cero) =Entero_Cero)THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'El Numero de CEDE No Existe';
			SET Var_Control 	:= 'creditoID' ;
			LEAVE ManejoErrores;
        END IF;

        IF(Par_NumValida=ConsultaAmortiza)THEN
			-- valida que el estatus sea autorizada
			IF(Var_Estatus <> Est_Vigente)THEN
				SET Par_NumErr 		:= 3;
				SET Par_ErrMen 		:= 'El CEDE No Esta Autorizado.';
				SET Var_Control 	:= 'clienteID' ;
				LEAVE ManejoErrores;
			END IF;
		ELSE
			IF(Par_NumValida=ConsultaCede)THEN
				IF(Var_Estatus <> Est_Vigente AND Var_Estatus<>Est_Registrada)THEN
					SET Par_NumErr 		:= 4;
					SET Par_ErrMen 		:= 'El Estatus del CEDE Es Incorrecto.';
					SET Var_Control 	:= 'clienteID' ;
					LEAVE ManejoErrores;
				END IF;
            END IF;
        END IF;

        SET Par_NumErr 		:= Entero_Cero;
		SET Par_ErrMen 		:= 'Consulta realizada Exitosamente';
		SET Var_Control 	:= 'cedeID' ;

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS control;
	END IF;

END TerminaStore$$