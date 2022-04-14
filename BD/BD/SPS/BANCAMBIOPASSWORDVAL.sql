-- BANCAMBIOPASSWORDVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS BANCAMBIOPASSWORDVAL;
DELIMITER $$

CREATE PROCEDURE BANCAMBIOPASSWORDVAL(
    Par_Contrasenia     VARCHAR(45),

    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN
    /*  Declaracion de   Constantes   */
    DECLARE Cadena_Vacia                    CHAR(1);
    DECLARE Fecha_Vacia                     DATETIME;
    DECLARE Entero_Cero                     INT(11);
    DECLARE Entero_Uno                      INT(11);            -- Entero uno
    DECLARE Con_Str_SI                      CHAR(1);
    DECLARE Con_Str_NO                      CHAR(1);
    DECLARE Var_Cantminima                  INT(11);
    DECLARE Var_Cantmayusculas              INT(11);
    DECLARE Var_Cantminusculas              INT(11);
    DECLARE Var_Cantnumeros                 INT(11);
    DECLARE Var_Cantespeciales              INT(11);
    DECLARE CaractMayusculas                VARCHAR(50);
    DECLARE CaractMinuscula                 VARCHAR(50);
    DECLARE CaractNumeros                   VARCHAR(50);        -- Caracteres numericos
    DECLARE CaractEspeciales                VARCHAR(50);        -- Caracteres especiales
    DECLARE HabilitaConfPass                VARCHAR(20);

    /*  Declaracion de   Variables   */
    DECLARE Var_HabilitaConfPass            CHAR(1);
    DECLARE Var_CaracterMinimo              INT(11);
    DECLARE Var_CaracterMayus               INT(11);
    DECLARE Var_CaracterMinus               INT(11);
    DECLARE Var_CaracterNumerico            INT(11);
    DECLARE Var_CaracterEspecial            INT(11);     
    DECLARE Var_UltimasContra               INT(11);   
    DECLARE Var_DiaMaxCamContra             INT(11);       
    DECLARE Var_DiaMaxInterSesion           INT(11);
    DECLARE Var_NumIntentos                 INT(11);
    DECLARE Var_NumDiaBloq                  INT(11);             
    DECLARE Var_ReqCaracterMayus            CHAR(1);
    DECLARE Var_ReqCaracterMinus            CHAR(1);
    DECLARE Var_ReqCaracterNumerico         CHAR(1);
    DECLARE Var_ReqCaracterEspecial         CHAR(1);
    DECLARE Var_ContadorCiclo               INT(11);                -- Posicion Actual del ciclo while
    DECLARE Var_ContadorMayus               INT(11);                -- Contador de Mayusculas
    DECLARE Var_ContadorMinus               INT(11);                -- Contador de Minusculas
    DECLARE Var_ContNumeros                 INT(11);                -- Contador de Numeros
    DECLARE Var_ContEspeciales              INT(11);                -- Contador de Especiales
    DECLARE Var_LongitudCad                 INT(11);                -- Longitud de la cadena  
    DECLARE Var_ContMayusculas              INT(11);                -- Contador de letas en Mayuscula
    DECLARE Var_Caracter                    CHAR(1);             -- Caracter actual

    /*  asignacion de Constantes   */
    SET Cadena_Vacia                    := '';                  -- Cadena Vacia
    SET Fecha_Vacia                     := '1900-01-01';        -- Fecha Vacia
    SET Entero_Cero                     := 0;                   -- Entero Cero
    SET Entero_Uno                      := 1;                   -- Entero uno
    SET Con_Str_SI                      := 'S';                 -- String de Si
    SET Con_Str_NO                      := 'N';                 -- String de No
    SET Var_Cantminima                  := 6;
    SET Var_Cantmayusculas              := 1;
    SET Var_Cantminusculas              := 1; 
    SET Var_Cantnumeros                 := 0;
    SET Var_Cantespeciales              := 1;
    SET HabilitaConfPass                := 'HabilitaConfPass';
    SET CaractMinuscula                 := 'abcdefghijklmnñopqrstuvwxyz';
    SET CaractEspeciales                := '0123456789!#%&/()=?¬¿+±*[]{}÷$._-|°';
    SET caractMayusculas                := 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ';
    SET CaractNumeros                   := '0123456789';

    /* Inicializar parametros de salida */
    SET     Par_NumErr              := 1;
    SET     Par_ErrMen              := Cadena_Vacia;

    ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr := 999;
                SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-CHEQUESBCAPLICAPRO');
            END;

        SELECT ValorParametro INTO Var_HabilitaConfPass 
            FROM PARAMGENERALES WHERE LLaveParametro = HabilitaConfPass;

        SELECT      CaracterMinimo,         CaracterMayus,          CaracterMinus,              CaracterNumerico,           CaracterEspecial,
                    UltimasContra,          DiaMaxCamContra,        DiaMaxInterSesion,          NumIntentos,                NumDiaBloq,
                    ReqCaracterMayus,       ReqCaracterMinus,       ReqCaracterNumerico,        ReqCaracterEspecial
            INTO    Var_CaracterMinimo,     Var_CaracterMayus,      Var_CaracterMinus,          Var_CaracterNumerico,       Var_CaracterEspecial,
                    Var_UltimasContra,      Var_DiaMaxCamContra,    Var_DiaMaxInterSesion,      Var_NumIntentos,            Var_NumDiaBloq,
                    Var_ReqCaracterMayus,   Var_ReqCaracterMinus,   Var_ReqCaracterNumerico,    Var_ReqCaracterEspecial
            FROM PARAMETROSSIS;

        IF(Var_HabilitaConfPass = Con_Str_SI) THEN
            SET Var_Cantminima := Var_CaracterMinimo;

            IF(Var_ReqCaracterMinus = Con_Str_SI) THEN
                SET Var_Cantminusculas := Var_CaracterMinus;
            END IF;
            
            IF(Var_ReqCaracterMayus = Con_Str_SI) THEN
                SET Var_Cantmayusculas := Var_CaracterMayus;
            END IF;

            IF(Var_ReqCaracterNumerico = Con_Str_SI) THEN
                SET Var_Cantnumeros := Var_CaracterNumerico;
            END IF;

            IF(Var_ReqCaracterEspecial = Con_Str_SI) THEN
                SET Var_Cantespeciales := Var_CaracterEspecial;
            END IF;
        END IF;


        SET Var_LongitudCad = LENGTH(Par_Contrasenia);
        SET Var_ContadorCiclo := Entero_Uno;
        SET Var_ContadorMayus := Entero_Cero;
        SET Var_ContadorMinus := Entero_Cero;
        SET Var_ContNumeros := Entero_Cero;
        SET Var_ContEspeciales := Entero_Cero;

        WHILE(Var_ContadorCiclo <= Var_LongitudCad) DO
            SET Var_Caracter := Cadena_Vacia;
            SET Var_Caracter := SUBSTRING(Par_Contrasenia, Var_ContadorCiclo, Entero_Uno);
            -- SELECT Var_Caracter;

            IF(INSTR(CaractMayusculas, BINARY Var_Caracter) > 0) then
                SET Var_ContadorMayus := Var_ContadorMayus + 1;
            END IF;
            
            IF(INSTR(CaractMinuscula, BINARY Var_Caracter) > 0) then
                SET Var_ContadorMinus := Var_ContadorMinus + 1;
            END IF;
            
            IF(POSITION(Var_Caracter IN CaractNumeros) > 0) then
                SET Var_ContNumeros := Var_ContNumeros + 1;
            END IF;
            
            IF(POSITION(Var_Caracter IN CaractEspeciales) > 0) then
                SET Var_ContEspeciales := Var_ContEspeciales + 1;
            END IF;

            SET Var_ContadorCiclo := Var_ContadorCiclo + 1;
        END WHILE;

        IF(Var_LongitudCad < Var_Cantminima) then
            SET Par_NumErr              := 1;
            SET Par_ErrMen              := CONCAT('Se requieren al menos ', Var_Cantminima, ' caracter(es).');
            LEAVE ManejoErrores;
        END IF;

        
        IF(Var_ContadorMayus < Var_Cantmayusculas) then
            SET Par_NumErr              := 2;
            SET Par_ErrMen              := CONCAT('Se requieren al menos ', Var_Cantmayusculas, ' caracter(es) en mayuscula.');
            LEAVE ManejoErrores;
        END IF;

        IF(Var_ContadorMinus < Var_Cantminusculas) then
            SET Par_NumErr              := 3;
            SET Par_ErrMen              := CONCAT('Se requieren al menos ', Var_Cantminusculas, ' caracter(es) en minuscula.');
            LEAVE ManejoErrores;
        END IF;


        IF(Var_ContNumeros < Var_Cantnumeros) then
            SET Par_NumErr              := 4;
            SET Par_ErrMen              := CONCAT('Se requieren al menos ', Var_Cantnumeros, ' caracter(es) numerico(s).');
            LEAVE ManejoErrores;
        END IF;

        IF(Var_ContEspeciales < Var_Cantespeciales) then
            SET Par_NumErr              := 5;
            SET Par_ErrMen              := CONCAT('Se requieren al menos ', Var_Cantespeciales, ' caracter(es) especial(es).');
            LEAVE ManejoErrores;
        END IF;
        

        SET Par_NumErr              := 0;
        SET Par_ErrMen              := 'Contrasenia correcta';
    END ManejoErrores;

    IF (Par_Salida = Con_Str_SI) THEN
        SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
                Par_ErrMen AS ErrMen,
                'contrasenia' AS control,
                Entero_Cero AS consecutivo;
    END IF;

END TerminaStore$$