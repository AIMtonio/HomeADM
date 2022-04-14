-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMDIASFRECUENCIACREDALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMDIASFRECUENCIACREDALT`;
DELIMITER $$

CREATE PROCEDURE `PARAMDIASFRECUENCIACREDALT`(

    Par_ProducCreditoID        	INT(11),
    Par_Frecuencia            	VARCHAR(1),
    Par_Dias                	INT(11),
    Par_Salida                 	CHAR(1),
    INOUT Par_NumErr        	INT(11),

    INOUT Par_ErrMen        	VARCHAR(400),

    Aud_Empresa                	INT(11),
    Aud_Usuario                	INT(11),
    Aud_FechaActual            	DATETIME,
    Aud_DireccionIP            	VARCHAR(15),

    Aud_ProgramaID            	VARCHAR(50),
    Aud_Sucursal            	INT(11),
    Aud_NumTransaccion        	BIGINT(20)
        	)
TerminaStore: BEGIN

    DECLARE Var_Control                VARCHAR(20);
    DECLARE Var_Consecutivo            VARCHAR(50);
    DECLARE Var_DescripcionFrec        VARCHAR(20);
    DECLARE Var_DiasFrecuencia         INT(11);
    DECLARE Var_Estatus                CHAR(2);        -- Almacena el estatus del producto de credito
    DECLARE Var_Descripcion            VARCHAR(100);   -- Almacena la descripcion del producto de credito

    DECLARE Cadena_Vacia                            VARCHAR(1);
    DECLARE Entero_Cero                             INT(11);
    DECLARE Cons_NO                                 CHAR(1);
    DECLARE Salida_SI                               CHAR(1);
    DECLARE PagoSemanal                             VARCHAR(1);
    DECLARE PagoDecenal                             VARCHAR(1);
    DECLARE PagoCatorcenal                          VARCHAR(1);
    DECLARE PagoQuincenal                           VARCHAR(1);
    DECLARE PagoMensual                             VARCHAR(1);
    DECLARE PagoPeriodo                             VARCHAR(1);
    DECLARE PagoBimestral                           VARCHAR(1);
    DECLARE PagoTrimestral                          VARCHAR(1);
    DECLARE PagoTetrames                            VARCHAR(1);
    DECLARE PagoSemestral                           VARCHAR(1);
    DECLARE PagoAnual                               VARCHAR(1);
    DECLARE PagoFinMes                              VARCHAR(1);
    DECLARE PagoAniver                              VARCHAR(1);
    DECLARE Cons_FrecExtDiasSemanal                 INT(11);
    DECLARE Cons_FrecExtDiasDecenal                 INT(11);
    DECLARE Cons_FrecExtDiasCatorcenal              INT(11);
    DECLARE Cons_FrecExtDiasQuincenal               INT(11);
    DECLARE Cons_FrecExtDiasMensual                 INT(11);
    DECLARE Cons_FrecExtDiasPeriodo                 INT(11);
    DECLARE Cons_FrecExtDiasBimestral               INT(11);
    DECLARE Cons_FrecExtDiasTrimestral              INT(11);
    DECLARE Cons_FrecExtDiasTetrames                INT(11);
    DECLARE Cons_FrecExtDiasSemestral               INT(11);
    DECLARE Cons_FrecExtDiasAnual                   INT(11);
    DECLARE Cons_FrecExtDiasFinMes                  INT(11);
    DECLARE Cons_FrecExtDiasAniver                  INT(11);
    DECLARE Estatus_Inactivo                        CHAR(1);    -- Estatus Inactivo

    SET Cadena_Vacia                := '';
    SET Entero_Cero                 := 0;
    SET Cons_NO                     := 'N';
    SET Salida_SI                   := 'S';

    SET Var_Control                 := 'producCreditoID';
    SET PagoSemanal                 := 'S';
    SET PagoDecenal                 := 'D';
    SET PagoCatorcenal              := 'C';
    SET PagoQuincenal               := 'Q';
    SET PagoMensual                 := 'M';
    SET PagoPeriodo                 := 'P';
    SET PagoBimestral               := 'B';
    SET PagoTrimestral              := 'T';
    SET PagoTetrames                := 'R';
    SET PagoSemestral               := 'E';
    SET PagoAnual                   := 'A';
    SET PagoFinMes                  := 'F';
    SET PagoAniver                  := 'A';
    SET Var_Consecutivo             := '';
    SET Cons_FrecExtDiasPeriodo     := 1;
    SET Cons_FrecExtDiasFinMes      := 1;
    SET Cons_FrecExtDiasAniver      := 1;
	SET Cons_FrecExtDiasSemanal		:= 5;
	SET Cons_FrecExtDiasDecenal		:= 5;
	SET Cons_FrecExtDiasCatorcenal	:= 10;
	SET Cons_FrecExtDiasQuincenal	:= 10;
	SET Cons_FrecExtDiasMensual		:= 20;
	SET Cons_FrecExtDiasBimestral	:= 40;
	SET Cons_FrecExtDiasTrimestral	:= 60;
	SET Cons_FrecExtDiasTetrames	:= 80;
	SET Cons_FrecExtDiasSemestral	:= 120;
	SET Cons_FrecExtDiasAnual		:= 240;
    SET Estatus_Inactivo            := 'I';      -- Estatus Inactivo

    SET Par_NumErr                  := 999;

    ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr  = 999;
            SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMDIASFRECUENCIACREDALT');
            SET Var_Control = 'sqlException';
        END;

        SELECT  Estatus,        Descripcion
        INTO    Var_Estatus,    Var_Descripcion
        FROM PRODUCTOSCREDITO
        WHERE ProducCreditoID = Par_ProducCreditoID;

        IF(IFNULL(Par_ProducCreditoID, Entero_Cero)) = Entero_Cero THEN
            SET    Par_NumErr    := 001;
            SET    Par_ErrMen    := 'El Numero de Producto de Credito Esta Vacio.';
            SET Var_Control    := 'producCreditoID';
            SET Var_Consecutivo := '';
            LEAVE ManejoErrores;
        ELSE
            IF NOT EXISTS(SELECT ProducCreditoID FROM PRODUCTOSCREDITO
                    WHERE ProducCreditoID = Par_ProducCreditoID) THEN
                SET    Par_NumErr    := 002;
                SET    Par_ErrMen    := 'El Producto de Credito No Existe.';
                SET Var_Control    := 'producCreditoID';
                SET Var_Consecutivo := '';
                LEAVE ManejoErrores;
            END IF;
        END IF;
        IF(IFNULL(Par_Frecuencia,Cadena_Vacia) = Cadena_Vacia) THEN
            SET    Par_NumErr    := 003;
            SET    Par_ErrMen    := 'La Frecuencia esta Vacia.';
            SET Var_Control    := 'frecuencia';
            SET Var_Consecutivo := '';
            LEAVE ManejoErrores;
        ELSE
            SET Var_DescripcionFrec := (SELECT DescInfinitivo
                                        FROM CATFRECUENCIAS
                                            WHERE FrecuenciaID = UPPER(Par_Frecuencia));
            SET Var_DescripcionFrec :=IFNULL(Var_DescripcionFrec,Cadena_Vacia);
            IF(Var_DescripcionFrec=Cadena_Vacia) THEN
                SET    Par_NumErr    := 004;
                SET    Par_ErrMen    := 'La Frecuencia No Existe.';
                SET Var_Control    := 'frecuencia';
                SET Var_Consecutivo := '';
                LEAVE ManejoErrores;
            ELSE
                IF EXISTS(SELECT ProducCreditoID FROM PARAMDIAFRECUENCRED
                    WHERE ProducCreditoID = Par_ProducCreditoID AND
                        Frecuencia=UPPER(Par_Frecuencia)) THEN
                    SET    Par_NumErr    := 005;
                    SET    Par_ErrMen    := CONCAT('La Parametrizacion ya se Encuentra Registrada para la Frecuencia ',Var_DescripcionFrec,'.');
                    SET Var_Control    := 'frecuencia';
                    SET Var_Consecutivo := '';
                    LEAVE ManejoErrores;
                END IF;
            END IF;
        END IF;


        SET Var_DiasFrecuencia := (CASE Par_Frecuencia
        WHEN PagoSemanal THEN Cons_FrecExtDiasSemanal
        WHEN PagoDecenal        THEN Cons_FrecExtDiasDecenal
        WHEN PagoCatorcenal     THEN Cons_FrecExtDiasCatorcenal
        WHEN PagoQuincenal      THEN Cons_FrecExtDiasQuincenal
        WHEN PagoMensual        THEN Cons_FrecExtDiasMensual
        WHEN PagoPeriodo        THEN Cons_FrecExtDiasPeriodo
        WHEN PagoBimestral      THEN Cons_FrecExtDiasBimestral
        WHEN PagoTrimestral     THEN Cons_FrecExtDiasTrimestral
        WHEN PagoTetrames       THEN Cons_FrecExtDiasTetrames
        WHEN PagoSemestral      THEN Cons_FrecExtDiasSemestral
        WHEN PagoAnual          THEN Cons_FrecExtDiasAnual
        WHEN PagoFinMes         THEN Cons_FrecExtDiasFinMes
        WHEN PagoAniver         THEN Cons_FrecExtDiasAniver
        ELSE
            1
        END);

        IF(Par_Dias > Var_DiasFrecuencia AND Par_Dias!=0) THEN
            SET    Par_NumErr    := 006;
            SET    Par_ErrMen    := CONCAT('Los Dias para Frecuencia ',Var_DescripcionFrec,' no Pueden ser Mayor o Igual a ',Var_DiasFrecuencia,' Dias.');
            SET Var_Control    := 'frecuencia';
            SET Var_Consecutivo := '';
            LEAVE ManejoErrores;
        END IF;


        IF(Var_Estatus = Estatus_Inactivo) THEN
            SET Par_NumErr      := 049;
            SET Par_ErrMen      := CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
            SET Var_Control     := 'producCreditoID';
            SET Var_Consecutivo := '';
            LEAVE ManejoErrores;
        END IF;

        SET Par_Frecuencia := UPPER(Par_Frecuencia);
        SET Aud_FechaActual := NOW();
        INSERT INTO PARAMDIAFRECUENCRED(
            ProducCreditoID,        Frecuencia,            Dias,                Usuario,
            EmpresaID,                FechaActual,        DireccionIP,        ProgramaID,
            Sucursal,                NumTransaccion)
        VALUES(
            Par_ProducCreditoID,    Par_Frecuencia,        Par_Dias,            Aud_Usuario,
            Aud_Empresa,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,            Aud_NumTransaccion);

        SET Par_NumErr := 000;
        SET Par_ErrMen := CONCAT('Informacion Grabada Exitosamente para el Producto: ',Par_ProducCreditoID,'.');
        SET Var_Control := 'producCreditoID';
        SET Var_Consecutivo := Par_ProducCreditoID;

    END ManejoErrores;

    IF(Par_Salida = Salida_SI) THEN
        SELECT Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS Control,
                Var_Consecutivo AS Consecutivo;
    END IF;

END TerminaStore$$