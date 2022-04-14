-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQACCESPRODCREALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQACCESPRODCREALT`;
DELIMITER $$


CREATE PROCEDURE `ESQACCESPRODCREALT`(
-- =============================================================
-- SP PARA DAR DE ALTA ESQUEMA DE ACCESORIOS POR CREDITO
-- =============================================================
	Par_ProducCreditoID 	INT(11), 		# Identificador del Producto de Crédito
	Par_AccesorioID			INT(11), 		# Identificador del Accesorio
	Par_ConvenioID			INT(11), 		# Identificador del Convenio
	Par_PlazoID				INT(11), 		# Identificador del Plazo
    Par_CicloIni 			INT(11), 		# Ciclo Inicio para el Esquema
    Par_CicloFin 			INT(11), 		# Cilco Final para el Esquema
	Par_MontoMin			DECIMAL(12,2),	# Monto Minimo para el Esquema
	Par_MontoMax			DECIMAL(12,2),	# Monto Maximo para el Esquema

	Par_Monto				DECIMAL(12,2), 	# Monto o Porcentaje del Esquema
	Par_NivelID				INT(11), 		# Identificador del Nivel
	Par_Salida				CHAR(1), 		# Salida, S:Si, N:No
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(500),

	/*Parametros de Auditoria*/
	Aud_EmpresaID 			INT(11),
	Aud_Usuario 			INT(11),
 	Aud_FechaActual 		DATETIME,
 	Aud_DireccionIP 		VARCHAR(15),
 	Aud_ProgramaID 			VARCHAR(50),
 	Aud_Sucursal 			INT(11),
 	Aud_NumTransaccion 		BIGINT(20)
)

TerminaStore:BEGIN

	/*Declaracion de Variables*/
	DECLARE Var_Control 			VARCHAR(50); 	# Variable Control en Pantalla
    DECLARE Var_Ciclo 				INT(11); 		# Variable Ciclo Auxiliar
    DECLARE Var_EstatusProducCred	CHAR(2);		# Estatus del Producto Credito
	DECLARE Var_Descripcion			VARCHAR(100);	# Descripcion Producto Credito


	/*Declaracion de Constantes*/
	DECLARE Salida_Si 			CHAR(1); 		# Constante Salida Si : S
    DECLARE Entero_Cero 		INT(11); 		# Constante Entero Cero
    DECLARE Decimal_Cero 		DECIMAL(12,2); 	# Constante Decimal Cero
    DECLARE Estatus_Inactivo    CHAR(1); 		# Estatus Inactivo


	/*Asignacion de Constantes*/
    SET Salida_Si 			:= 'S'; 		# Constante Salida Si
    SET Entero_Cero 		:= 0; 			# Constante Entero Cero
    SET Decimal_Cero		:= 0.0; 		# Constante Decimal Cero
	SET Estatus_Inactivo	:= 'I';			# Estatus Inactivo

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocaciones. Ref: SP-ESQACCESPRODCREALT');
			SET Var_Control	:='SQLEXCEPTION';
		END;

        IF(IFNULL(Par_ProducCreditoID,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr 	:= 1;
            SET Par_ErrMen 	:= 'El producto de credito esta vacio';
            SET Var_Control := 'producCreditoID';
            LEAVE ManejoErrores;
        END IF;

		IF(IFNULL(Par_AccesorioID,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr 	:= 2;
            SET Par_ErrMen 	:= 'El accesorio esta vacio';
            SET Var_Control := 'accesorioID';
            LEAVE ManejoErrores;
        END IF;

		IF(IFNULL(Par_PlazoID,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr 	:= 3;
            SET Par_ErrMen 	:= 'El plazo esta vacio';
            SET Var_Control := 'plazoID';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_CicloIni,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr 	:= 4;
            SET Par_ErrMen 	:= 'El Ciclo Inicial esta vacio';
            SET Var_Control := 'cicloIni';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_CicloFin,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr 	:= 5;
            SET Par_ErrMen 	:= 'El Ciclo Final esta vacio';
            SET Var_Control := 'cicloFin';
            LEAVE ManejoErrores;
        END IF;

		IF(IFNULL(Par_MontoMin,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr 	:= 6;
            SET Par_ErrMen 	:= 'El Monto Minimo esta vacio';
            SET Var_Control := 'montoMin';
            LEAVE ManejoErrores;
        END IF;

		IF(IFNULL(Par_MontoMax,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr 	:= 7;
            SET Par_ErrMen 	:= 'El Monto Maximo esta vacio';
            SET Var_Control := 'montoMax';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_Monto,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr 	:= 8;
            SET Par_ErrMen 	:= 'El Monto esta vacio';
            SET Var_Control := 'monto';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_MontoMax < Par_MontoMin) THEN
        	SET Par_NumErr	:= 9;
        	SET Par_ErrMen	:= 'El monto Máximo no puede ser menor al Monto Minimo';
        	SET Var_Control	:= 'montoMax';
        	LEAVE ManejoErrores;
        END IF;

        -- Sección valida ciclo inicial y final
        SET Var_Ciclo := (SELECT PlazoID FROM ESQCOBROACCESORIOS
						WHERE ProductoCreditoID = Par_ProducCreditoID
						AND AccesorioID = Par_AccesorioID
						AND ConvenioID = Par_ConvenioID
						AND PlazoID = Par_PlazoID
						AND Par_CicloIni BETWEEN CicloIni AND CicloFin
						AND (Par_MontoMin BETWEEN MontoMin AND MontoMax
							OR Par_MontoMax BETWEEN MontoMin AND MontoMax)
                        LIMIT 1);

		SET Var_Ciclo := IFNULL(Var_Ciclo,Entero_Cero);
        IF(Var_Ciclo=Entero_Cero)THEN
			-- Si el ciclo inicial es válido, evalua ciclo final
			SET Var_Ciclo := (SELECT PlazoID FROM ESQCOBROACCESORIOS
						WHERE ProductoCreditoID = Par_ProducCreditoID
						AND AccesorioID = Par_AccesorioID
						AND ConvenioID = Par_ConvenioID
						AND PlazoID = Par_PlazoID
						AND (Par_MontoMin BETWEEN MontoMin AND MontoMax
							OR Par_MontoMax BETWEEN MontoMin AND MontoMax)
						AND (Par_CicloFin BETWEEN CicloIni AND CicloFin
							OR (Par_CicloIni< CicloIni AND Par_CicloFin >= CicloFin))
                        LIMIT 1);
			SET Var_Ciclo := IFNULL(Var_Ciclo,Entero_Cero);
            IF(Var_Ciclo<>Entero_Cero)THEN
				SET Par_NumErr := 9;
				SET Par_ErrMen := 'El Ciclo Final o Monto Máximo de un Esquema ya se encuentra parametrizado';
				SET Var_Control := '';
				LEAVE ManejoErrores;
            END IF;
		ELSE
			SET Par_NumErr := 10;
			SET Par_ErrMen := 'El Ciclo Inicial o Mínimo Mínimo de un Esquema ya se encuentra parametrizado';
			SET Var_Control := '';
            LEAVE ManejoErrores;
        END IF;

        SELECT 	Estatus, 				Descripcion
		INTO	Var_EstatusProducCred,	Var_Descripcion
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID = IFNULL(Par_ProducCreditoID, Entero_Cero);

        IF(Var_EstatusProducCred = Estatus_Inactivo) THEN
			SET Par_NumErr := 011;
			SET Par_ErrMen := CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
			SET Var_Control:= 'producCreditoID' ;
			LEAVE ManejoErrores;
		END IF;


        INSERT INTO ESQCOBROACCESORIOS(
			ProductoCreditoID, 		ConvenioID,			PlazoID, 			CicloIni,			CicloFin,
			MontoMin,				MontoMax,			AccesorioID,		Porcentaje, 		NivelID,
			EmpresaID,				Usuario, 			FechaActual,		DireccionIP, 		ProgramaID,
			Sucursal, 				NumTransaccion
        )VALUES(
			Par_ProducCreditoID, 	Par_ConvenioID,	 	Par_PlazoID, 		Par_CicloIni,		Par_CicloFin,
			Par_MontoMin,			Par_MontoMax,		Par_AccesorioID,	Par_Monto, 			Par_NivelID,
			Aud_EmpresaID,      	Aud_Usuario, 		Aud_FechaActual,	Aud_DireccionIP, 	Aud_ProgramaID,
			Aud_Sucursal,    		Aud_NumTransaccion
        );

        SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Esquemas Grabados Exitosamente';
		SET Var_Control := 'accesorioID';

	END ManejoErrores;

	IF(Par_Salida=Salida_Si)THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control;
	END IF;

END TerminaStore$$