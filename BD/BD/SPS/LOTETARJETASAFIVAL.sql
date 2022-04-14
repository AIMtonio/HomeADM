
-- LOTETARJETASAFIVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `LOTETARJETASAFIVAL`;
DELIMITER $$

CREATE PROCEDURE `LOTETARJETASAFIVAL`(

    Par_LoteDebitoSAFIID        INT(11),
	Par_Estatus				    INT(11),
    Par_NomArchiGen			    VARCHAR(50),

    Par_Salida				    CHAR(1),
	INOUT Par_NumErr    	    INT(11),
    INOUT Par_ErrMen    	    VARCHAR(400),

    Par_EmpresaID               INT(11),
    Aud_Usuario                 INT(11),
    Aud_FechaActual             DATETIME,
    Aud_DireccionIP             VARCHAR(15),
    Aud_ProgramaID              VARCHAR(50),
    Aud_Sucursal                INT(11),
    Aud_NumTransaccion          BIGINT(20)
	)
TerminaStore: BEGIN

DECLARE	Var_LoteTarjetaDebSAFIID	INT(11);
DECLARE Var_Control				VARCHAR(50);
DECLARE Var_Consecutivo			INT;


DECLARE Entero_Uno	  		INT;
DECLARE Entero_Cero		 	INT;
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Salida_NO 		 	CHAR(1);
DECLARE	SalidaSI	 	 	CHAR(1);
DECLARE Salto_Linea        	VARCHAR(2);
DECLARE Var_Inactivo        CHAR(1);    -- Inactivo
DECLARE Act_Cancelacion     TINYINT;        -- Opcion para cancelacion


SET Var_LoteTarjetaDebSAFIID	:= 0;


SET Entero_Uno   	:= 1;
SET	Entero_Cero		:= 0;
SET	Cadena_Vacia	:= '';
SET	Salida_NO		:= 'N';
SET	SalidaSI		:= 'S';
SET Salto_Linea     :='\n';
SET Var_Inactivo    := 'I';
SET Act_Cancelacion := 1;       -- Opcion para cancelacion

ManejoErrores:BEGIN

   DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-LOTETARJETASAFIVAL');
    END;

    SELECT (MAX(LoteDebSAFIID)) INTO Var_LoteTarjetaDebSAFIID
					FROM LOTETARJETADEBSAFI WHERE Estatus=Entero_Uno  AND RutaNomArch=Cadena_Vacia ;

    IF(Var_LoteTarjetaDebSAFIID=Entero_Cero)THEN

            SET Par_NumErr := 0;
            SET Par_ErrMen := CONCAT('Operacion Realizada Exitosamente. ',
                                    'Error al copiar el archivo generado. Favor de Comunicarse al Area de Sistemas');
            LEAVE ManejoErrores;

     END IF;

    SET Var_LoteTarjetaDebSAFIID:= IFNULL( Var_LoteTarjetaDebSAFIID, Entero_Cero);

	IF(Var_LoteTarjetaDebSAFIID>Entero_Cero)THEN

        CALL TARDEBASIGNADASBAJ(
            Var_LoteTarjetaDebSAFIID,       Salida_NO,                  Par_NumErr,                 Par_ErrMen,                 Par_EmpresaID,
            Aud_Usuario,                    Aud_FechaActual,            Aud_DireccionIP,            Aud_ProgramaID,             Aud_Sucursal,
            Aud_NumTransaccion
        );

        CALL TMP_TARDEBASIGNADASACT(
            Entero_Cero,            Act_Cancelacion,            Salida_NO,                  Par_NumErr,                 Par_ErrMen,
            Par_EmpresaID,          Aud_Usuario,                Aud_FechaActual,            Aud_DireccionIP,            Aud_ProgramaID,
            Aud_Sucursal,           Aud_NumTransaccion
        );

        CALL TARLAYDEBSAFIBAJ(Var_LoteTarjetaDebSAFIID,Entero_Uno,Salida_NO,Par_NumErr, Par_ErrMen,Par_EmpresaID,
        Aud_Usuario,Aud_FechaActual,Aud_DireccionIP, Aud_ProgramaID, Aud_Sucursal,Aud_NumTransaccion);

		CALL LOTETARJETASAFIBAJ(Var_LoteTarjetaDebSAFIID,Entero_Uno,Salida_NO,Par_NumErr, Par_ErrMen,Par_EmpresaID,
		Aud_Usuario,Aud_FechaActual,Aud_DireccionIP, Aud_ProgramaID, Aud_Sucursal,Aud_NumTransaccion);

        -- SI EL PROCESO FALLA SE CAMBIA EL ESTATUS.
        UPDATE   TMPGENERALOTTARPRO
            SET EstatusProceso = Var_Inactivo;

        IF (Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;
	END IF;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'habilitadoSAFI' AS control,
            Var_Consecutivo AS Var_LoteTarjetaDebSAFIID;
END IF;

END TerminaStore$$
