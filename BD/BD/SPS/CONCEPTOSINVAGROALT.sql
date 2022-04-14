-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSINVAGROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOSINVAGROALT`;DELIMITER $$

CREATE PROCEDURE `CONCEPTOSINVAGROALT`(
# =====================================================================================
# ------- STORE PARA  DAR DE ALTA CONCEPTOS  DE INVERSION---------
# =====================================================================================
	Par_SolicitudID		BIGINT(20),				-- Solicitud de credito
    Par_ClienteID		INT(11),				-- ID dcel cliente
	Par_FechaRegistro	DATE,					-- FechaA de registro

    Par_ConceptoInvID   INT(11),         		-- ID del concepto Fira.
    Par_NoUnidad   		DECIMAL(16,2),         		-- No de Unidades
    Par_ClaveUnidad   	VARCHAR(45),          		-- Clave de Unidad
    Par_Unidad   		VARCHAR(45),          		-- Concepto de Unidad


    Par_Monto   		DECIMAL(16,2),          -- Monto del concepto
	Par_TipoRecurso		CHAR(2),				-- Tipo de recurso.

    Par_Salida          CHAR(1),            	-- indca una salida
    INOUT Par_NumErr    INT(11),				-- numero de error
    INOUT Par_ErrMen    VARCHAR(400),			-- mensaje de error

    Par_EmpresaID       INT(11),    			-- parametros de auditoria
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

    -- Declacion de Variables
    DECLARE Var_Control         VARCHAR(100); 			-- Variable de control
    DECLARE Var_Consecutivo     BIGINT(20);     		-- consecutivo
	DECLARE Var_ClienteID       INT(11);				-- clienteID
	DECLARE Var_SaldoTotal 		DECIMAL(14,2);			-- Saldo Disponible del credito
	DECLARE Var_ConcepFiraID    INT(11);				-- ID concepto Fira
	DECLARE Var_SolicitudCre	BIGINT(20);				-- ID de la solicitud
    DECLARE Var_MontoTotal		DECIMAL(16,2);			-- monto
    DECLARE Var_MontoSolici		DECIMAL(14,2);
    DECLARE Var_NoUnidad		DECIMAL(14,2);			-- No de Unidades
    DECLARE Var_ClaveUnidad     VARCHAR(100); 			-- Clave de Unidad
    DECLARE Var_Unidad          VARCHAR(100); 			-- Unidad

    -- Declaracion de constantes
    DECLARE Entero_Cero         INT(11);				-- entero cero
    DECLARE Entero_Uno			INT(11);				-- entero uno
    DECLARE Cadena_Vacia        CHAR(1);				-- cadena vacia
    DECLARE Salida_SI           CHAR(1);    			-- salida si
    DECLARE Salida_NO           CHAR(1);    			-- salida no
    DECLARE Decimal_Cero        DECIMAL(14,2);			-- DECIMAL cero
	DECLARE Fecha_Vacia  		DATE;					-- fecha vacia
    DECLARE DescripcionMov		VARCHAR(100);			-- descripcion del novimiento en caso de que venga vacio
	DECLARE Es_Agropecuario		CHAR(1);				-- INDICA QUE SI ES AGRO
    DECLARE Recurso_Prestamo	CHAR(1);				-- SECCION RECURSOS DEL PRESTAMO
    -- Asignacion de constantes
    SET Entero_Cero         := 0;               -- Entero Cero
    SET Entero_Uno			:= 1;				-- Entero Uno
    SET Cadena_Vacia        := '';              -- Cadena Vacia
    SET Salida_SI           := 'S';             -- Salida en Pantalla SI
    SET Salida_NO           := 'N';             -- Salida en Pantalla NO
    SET Decimal_Cero        := 0.00;            -- DECIMAL Cero
    SET Es_Agropecuario		:= 'S';
	SET Fecha_Vacia     	:= '1900-01-01';
    SET Recurso_Prestamo	:= 'P';

    ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
                SET Par_NumErr  := 999;
                SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-CONCEPTOSINVAGROALT');
                SET Var_Control := 'SQLEXCEPTION';
		END;

		-- Asignamos valor por defaul a varibles
		SET Aud_FechaActual  	:=  NOW();

		 IF(IFNULL(Par_SolicitudID, Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr := 1;
            SET Par_ErrMen := 'El Numero de Solicitud Esta Vacio.';
            SET Var_Control:= 'solicitudCreditoID' ;
            LEAVE ManejoErrores;
         END IF;

         SELECT  SolicitudCreditoID, MontoSolici    INTO    Var_SolicitudCre  , Var_MontoSolici
            FROM SOLICITUDCREDITO
            WHERE  SolicitudCreditoID  = Par_SolicitudID
				AND ClienteID =Par_ClienteID
                AND EsAgropecuario = Es_Agropecuario;

		IF(IFNULL(Var_SolicitudCre, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'El Numero de Solicitud No Existe.';
			SET Var_Control:= 'solicitudCreditoID' ;
			LEAVE ManejoErrores;
		 END IF;

        IF(IFNULL(Par_ClienteID, Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr := 3;
            SET Par_ErrMen := 'El Numero de Cliente esta Vacio.';
            SET Var_Control:= 'clienteID' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_ConceptoInvID, Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr := 4;
            SET Par_ErrMen := 'El Concepto Fira esta Vacio.';
            SET Var_Control:= 'conceptoInvID' ;
            LEAVE ManejoErrores;
        END IF;

        SELECT  ConceptoFiraID     INTO    Var_ConcepFiraID
            FROM CATCONCEPTOSINVERAGRO
            WHERE  ConceptoFiraID  = Par_ConceptoInvID;

        IF(IFNULL(Var_ConcepFiraID, Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr := 5;
            SET Par_ErrMen := 'El Concepto Fira No Existe.';
            SET Var_Control:= 'conceptoInvID' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_Monto, Decimal_Cero) = Decimal_Cero) THEN
            SET Par_NumErr := 6;
            SET Par_ErrMen := 'El Monto de Concepto esta Vacio.';
            SET Var_Control:= 'monto' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_TipoRecurso, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr := 7;
            SET Par_ErrMen := 'El Monto de Concepto esta Vacio.';
            SET Var_Control:= 'tipoRecurso' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_FechaRegistro, Fecha_Vacia) = Fecha_Vacia) THEN
            SET Par_NumErr := 8;
            SET Par_ErrMen := 'La Fecha de Registro esta Vacia.';
            SET Var_Control:= 'fechaRegistro' ;
            LEAVE ManejoErrores;
        END IF;


         IF(Par_FechaRegistro= Recurso_Prestamo) THEN

            SET Var_MontoTotal:= (SELECT SUM(Monto) FROM CONCEPTOINVERAGRO
				WHERE SolicitudCreditoID = Par_SolicitudID
					AND ClienteID= Par_ClienteID
						AND TipoRecurso = Recurso_Prestamo);

            IF(Var_MontoSolici <>Var_MontoTotal)THEN
				SET Par_NumErr := 9;
				SET Par_ErrMen := 'La Suma de los Recursos del Prestamo No Coinciden con el Monto de La Solicitud de Credito.';
				SET Var_Control:= 'solicitudCreditoID' ;
				LEAVE ManejoErrores;
            END IF;

        END IF;

          IF(IFNULL(Par_NoUnidad, Decimal_Cero) = Decimal_Cero) THEN
            SET Par_NumErr := 10;
            SET Par_ErrMen := 'El Monto de No Unidad esta Vacio.';
            SET Var_Control:= 'monto' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_ClaveUnidad, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr := 11;
            SET Par_ErrMen := 'El ID de la Unidad esta Vacio.';
            SET Var_Control:= 'tipoRecurso' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_Unidad, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr := 12;
            SET Par_ErrMen := 'La descripcion de la Unidad esta Vacio.';
            SET Var_Control:= 'tipoRecurso' ;
            LEAVE ManejoErrores;
        END IF;

        SELECT (MAX(ConceptoInvID)+Entero_Uno) INTO Var_Consecutivo
			FROM  CONCEPTOINVERAGRO;

		SET Var_Consecutivo := IFNULL(Var_Consecutivo,Entero_Uno);


        INSERT INTO CONCEPTOINVERAGRO(
			ConceptoInvID, 		SolicitudCreditoID,		ClienteID, 		ConceptoFiraID, 	FechaRegistro,
            NoUnidad,			ClaveUnidad,			Unidad,			Monto, 				TipoRecurso,
 			EmpresaID, 		Usuario, 					FechaActual,     DireccionIP, 		ProgramaID,
            Sucursal, 		NumTransaccion)
		VALUES(
			Var_Consecutivo,  	Par_SolicitudID,		Par_ClienteID,  Par_ConceptoInvID, 	Par_FechaRegistro,
            Par_NoUnidad,		Par_ClaveUnidad,		Par_Unidad,		Par_Monto,  		Par_TipoRecurso,
            Par_EmpresaID,  Aud_Usuario,    	Aud_FechaActual,        Aud_DireccionIP,	Aud_ProgramaID,
            Aud_Sucursal,   Aud_NumTransaccion);

		SET     Par_NumErr 		:= 0;
		SET     Par_ErrMen 		:= CONCAT('Conceptos de Inversion Agregados Exitosamente a la Solicitud: ', CONVERT(Par_SolicitudID, CHAR));
		SET     Var_Control 	:= 'solicitudCreditoID';
        SET     Var_Consecutivo := Par_SolicitudID;

    END ManejoErrores;

       IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr 		AS NumErr,
					Par_ErrMen 		AS ErrMen,
					Var_Control 	AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$