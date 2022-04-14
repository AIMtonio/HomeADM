DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2PLANEJECUCIONALT`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2PLANEJECUCIONALT`(
    -- SP que genera informacion del Estado Cuenta
	Par_Salida			CHAR(1),		-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),

    -- Parametros de Auditoria
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore: BEGIN

    DECLARE Entero_Uno              INT(11);
    DECLARE Var_Contador            INT(11);
    DECLARE Var_Contadorsuc         INT(11); 

    DECLARE Var_EmpresaID           INT(11);
    DECLARE Var_Usuario             INT(11);
    DECLARE Var_FechaActual         DATETIME;
    DECLARE Var_DireccionIP         VARCHAR(15);
    DECLARE Var_ProgramaID          VARCHAR(50);
    DECLARE Var_Sucursal            INT(11);      
    DECLARE Var_NumTransaccion      BIGINT(20);
    DECLARE Var_SucursalID          INT(11);
    DECLARE Var_SucursalMenor       INT(11);
    DECLARE Var_SalidaSI            CHAR(1);
    DECLARE Var_SalidaNO            CHAR(1);

    -- DECLARACION DE VARIABLES
	DECLARE Var_FechaSis		DATE;
	DECLARE Var_FolioProceso	BIGINT(20);
	DECLARE Var_AnioMes			INT(11);
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_FecIniMes		DATE;						-- Fecha inicial del Periodo a procesar
	DECLARE Var_FecFinMes		DATE;						-- Fecha final del Periodo a Procear
    DECLARE Constante_Si		CHAR(1);
    DECLARE Entero_Cero			INT(11);

    SET	Entero_Uno		            := 1;
    SET Constante_Si		        := 'S';
    SET Var_EmpresaID               := 1;
    SET Var_Usuario                 := 1;  
    SET Var_DireccionIP             := '127.0.0.1';
    SET Var_ProgramaID              := 'ETL-Edocta';
    SET Var_Sucursal                := 1;
    SET Var_NumTransaccion          := 999;
    SET Var_Contador                 =0;
    SET Var_SalidaSi                := 'S';
    SET Var_SalidaNo                := 'N';
    SET Entero_Cero			        := 0;

    ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAV2PLANEJECUCIONALT');
			SET Var_Control	= 'sqlException';
		END;

    SELECT	MesProceso,  FechaInicio, 	FechaFin,  		FolioProceso
		INTO	Var_AnioMes, Var_FecIniMes, Var_FecFinMes, 	Var_FolioProceso
		FROM	EDOCTAV2PARAMS
		LIMIT	1;

		SET Var_FolioProceso 	:= IFNULL(Var_FolioProceso, Entero_Cero);

    SELECT FechaSistema INTO Var_FechaActual FROM PARAMETROSSIS;
    SELECT COUNT(*) INTO  Var_Contadorsuc FROM SUCURSALES s ;

    DELETE FROM EDOCTAV2PLANEJECUCION;

    WHILE (Var_Contador < Var_Contadorsuc) DO 

        SELECT SucursalID INTO Var_SucursalID FROM SUCURSALES s order by SucursalID LIMIT Var_Contador, Entero_Uno;
        
        INSERT INTO EDOCTAV2PLANEJECUCION (EjecucionID,     TipoEjecucion,      EjecucionJobPdf,        EjecucionJobTim,        EjecucionSPPrin, 
                                           Instrumentos,	Usuario,            FechaActual,            DireccionIP, 		    ProgramaID, 
                                           Sucursal,  NumTransaccion)
                                   VALUES (Var_Contador+1,    Var_SalidaSi,       Var_SalidaSi,           Var_SalidaSi,           Var_SalidaSi,
                                           Var_SucursalID,  Var_Usuario,        Var_FechaActual,        Var_DireccionIP,        Var_ProgramaID, 
                                           Var_SucursalID, Var_NumTransaccion);
            
    SET Var_Contador = Var_Contador + 1;
    END WHILE;

    SELECT Min(Instrumentos) INTO Var_SucursalMenor FROM EDOCTAV2PLANEJECUCION;
    UPDATE EDOCTAV2PLANEJECUCION
        SET EjecucionJobPdf = 'S',
            EjecucionJobTim = 'N',
            EjecucionSPPrin = 'N'
        WHERE Instrumentos <> Var_SucursalMenor;

    SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Datos Sucursales del Cliente Terminado exitosamente con Folio: ', CAST(Var_FolioProceso AS CHAR));
		SET Var_Control	:= 'EDOCTAV2PLANEJECUCIONALT';
    END ManejoErrores;

	IF (Par_Salida = Constante_Si) THEN
		SELECT	Par_NumErr			AS NumErr,
				Par_ErrMen			AS ErrMen,
				Var_FolioProceso	AS control;
	END IF;

END TerminaStore$$