-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_LINEACIEDIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_LINEACIEDIAPRO`;
DELIMITER $$


CREATE PROCEDURE `TC_LINEACIEDIAPRO`(
-- ---------------------------------------------------------------------------------
-- SP para el Proceso de Cierre de Lineas de Credito
-- ---------------------------------------------------------------------------------
    Par_Fecha           DATE,               -- Fecha de Cierre

    Par_Salida          CHAR(1),            -- Parametro de Salida
    INOUT Par_NumErr    INT(11),            -- Numero de Error
    INOUT Par_ErrMen    VARCHAR(400),       -- Descripcion del Error

    Par_EmpresaID       INT(11),            -- Auditoria
    Aud_Usuario         INT(11),            -- Auditoria
    Aud_FechaActual     DATETIME,           -- Auditoria
    Aud_DireccionIP     VARCHAR(15),        -- Auditoria

    Aud_ProgramaID      VARCHAR(50),        -- Auditoria
    Aud_Sucursal        INT(11),            -- Auditoria
    Aud_NumTransaccion  BIGINT              -- Auditoria
)

TerminaStore: BEGIN

    
    DECLARE Var_FechaBatch          DATE;           -- Fecha batch
    DECLARE Var_FecBitaco           DATETIME;       -- Fecha bitacora
    DECLARE Var_MinutosBit          INT(11);        -- Minuto bitacora
    DECLARE Sig_DiaHab              DATE;           -- DiaHabil
    DECLARE Var_EsHabil             CHAR(1);        -- Es habil
    DECLARE Fec_Calculo             DATE;           -- Fecha Calculo
    DECLARE Var_UltimoDiaMes        DATE;  			-- Ultimo dia mes
    DECLARE Var_NumeroTC      		INT;			-- 

    
    DECLARE Cadena_Vacia            CHAR(1);		-- Cadena vacia
    DECLARE Fecha_Vacia             DATE;			-- Fecha vacia
    DECLARE Entero_Cero             INT(11);		-- Entero cero
    DECLARE Un_DiaHabil             INT(11);		-- Un Dia habil
    DECLARE Es_DiaHabil             CHAR(1);		-- Es dia habil
    DECLARE SalidaNO                CHAR(1);		-- SALIDA NO
    DECLARE Pro_ComAp               INT(11);		-- Proceso
    DECLARE Cons_SI                 CHAR(1);    	-- CONSTANTE SI
    DECLARE Cons_NO                 CHAR(1);		-- CONSTANTE NO

    DECLARE Pro_CieTarCred          INT(11);		-- CIERRE TARJETAS CREDITO
    DECLARE Pro_CieSaldos           INT(11);		-- CIERRE SALDOS
    DECLARE Pro_CiePeriodo          INT(11);		-- CIERRE PERIODOS
    DECLARE Pro_CieIntOrd           INT(11);		-- CIERRE INTERNO ORDINADRIO
    DECLARE Est_Vigente             CHAR(1);		-- Estatus vigente
    


    -- Asignacion de constantes
    SET Cadena_Vacia    := ''; 					-- cadena vacia
    SET Fecha_Vacia     := '1900-01-01';		-- Fecha Vacia
    SET Entero_Cero     := 0;					-- Entero cero
    SET Aud_ProgramaID  := 'TC_LINEACIEDIAPRO';	-- Programa id

    SET Var_FecBitaco   := NOW();				-- Fecha bitacora reg
    SET Un_DiaHabil     := 1;					-- Dia Inhabil
    
    SET Cons_SI         := 'S';					-- Constante SI
    SET Cons_NO         := 'N';     			-- Constante NO
    
    SET Pro_CieSaldos   := 9012;    			-- Proceso cierre saldos
    SET Pro_CiePeriodo  := 9013;    			-- Proceso cierre periodos
    SET Pro_CieIntOrd   := 9014;    			-- Proceso cierre interno ordinario
    SET Pro_CieTarCred  := 9011;    			-- Proceso cierre tarjeta de credito

    SET Est_Vigente     := 'A';     			-- Estatus vigente

    ManejoErrores:BEGIN

       DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr  = 999;
                SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-TC_LINEACIEDIAPRO');  
            END;


        SET Var_UltimoDiaMes := LAST_DAY(Par_Fecha);

        SELECT Fecha INTO Var_FechaBatch
            FROM BITACORABATCH
            WHERE Fecha             = Par_Fecha
              AND ProcesoBatchID    = Pro_CieTarCred;

        SET Var_FechaBatch := IFNULL(Var_FechaBatch, Fecha_Vacia);

        IF Var_FechaBatch != Fecha_Vacia THEN
            LEAVE TerminaStore;
        END IF;

        SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

        CALL BITACORABATCHALT(
            Pro_CieTarCred,     Par_Fecha,          Var_MinutosBit,     Par_EmpresaID,      Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

        SET Var_FecBitaco := NOW();

        CALL DIASFESTIVOSCAL(
            Par_Fecha,      1,                  Sig_DiaHab,         Var_EsHabil,    Par_EmpresaID,
            Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
            Aud_NumTransaccion);

        SET Fec_Calculo := Par_Fecha;

        SELECT COUNT(LineaTarCredID) 
        INTO Var_NumeroTC
		FROM LINEATARJETACRED;

        SET Var_NumeroTC := IFNULL(Var_NumeroTC,Entero_Cero);
        IF Var_NumeroTC = Entero_Cero THEN
			SET Par_NumErr := 0;
			SET Par_ErrMen := 'CIERRE DE TARJETAS CREDITO REALIZADO EXITOSAMENTE';
				LEAVE ManejoErrores;
		END IF;

        
        WHILE (Fec_Calculo < Sig_DiaHab) DO

            SET Aud_FechaActual := NOW();

        /*
            CALL TC_GENCOMINTERESORDPRO(
                        Fec_Calculo,        SalidaNO ,          Par_NumErr,         Par_ErrMen,             Par_EmpresaID,      
                        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,           
                        Aud_NumTransaccion);

            IF Par_NumErr <> Entero_Cero THEN
                LEAVE ManejoErrores;
            END IF;
            
            SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

            CALL BITACORABATCHALT(
                Pro_CieIntOrd,      Fec_Calculo,          Var_MinutosBit,     Par_EmpresaID,      Aud_Usuario,
                Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

            SET Var_FecBitaco := NOW();
        */
            IF Fec_Calculo = Var_UltimoDiaMes THEN
                CALL TC_CALCULOSALDOSPRO(
                        Fec_Calculo,        SalidaNO ,          Par_NumErr,         Par_ErrMen,             Par_EmpresaID,      
                        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,
                        Aud_NumTransaccion);

                IF Par_NumErr <> Entero_Cero THEN
                    LEAVE ManejoErrores;
						END IF;
						SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

						CALL BITACORABATCHALT(
						Pro_CieSaldos,      Fec_Calculo,          Var_MinutosBit,     Par_EmpresaID,      Aud_Usuario,
						Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

						SET Var_FecBitaco := NOW();
				END IF;

				CALL TC_PERIODOSLINEAPRO(   
						Fec_Calculo,        SalidaNO ,          Par_NumErr,         Par_ErrMen,         Par_EmpresaID,      
						Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,           
						Aud_NumTransaccion);

            IF Par_NumErr <> Entero_Cero THEN
                LEAVE ManejoErrores;
            END IF;
            
            SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

            CALL BITACORABATCHALT(
                Pro_CiePeriodo,     Fec_Calculo,          Var_MinutosBit,     Par_EmpresaID,      Aud_Usuario,
                Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

            SET Var_FecBitaco := NOW();
            SET Fec_Calculo := ADDDATE(Fec_Calculo, 1);

        END WHILE;


        SET Par_NumErr := 0;
        SET Par_ErrMen := 'CIERRE DE TARJETAS CREDITO REALIZADO EXITOSAMENTE';

    END ManejoErrores; 

    IF Par_Salida != SalidaNO THEN
        SELECT Par_NumErr  AS NumErr,
               Par_ErrMen  AS ErrMen;

    END IF;

END TerminaStore$$
