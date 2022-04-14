DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCREPAGCRECAMORPRO`;
DELIMITER $$
CREATE PROCEDURE `BANCREPAGCRECAMORPRO`(

	Par_Monto				DECIMAL(14,2),
	Par_Tasa				DECIMAL(14,2),
	Par_Frecu				INT,
	Par_PagoCuota			CHAR(1),
	Par_FechaInicio			DATE	,
	Par_NumeroCuotas		INT,
	Par_ProdCredID			INT,
	Par_ClienteID			INT,


	Par_ComAper				DECIMAL(14,2),
	Par_Salida    			CHAR(1),
    INOUT	Par_NumErr 		INT,
    INOUT	Par_ErrMen  	VARCHAR(350),
    INOUT	Par_NumTran		BIGINT(20),
    INOUT 	Par_Cuotas		INT,
    INOUT	Par_Cat			DECIMAL(14,4),
    INOUT	Par_MontoCuo	DECIMAL(14,4),
	INOUT	Par_FechaVen 	DATE,

	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
)
TerminaStore: BEGIN

	DECLARE Var_FinAni			CHAR(1);
	DECLARE Var_DiaHabilSig		CHAR(1);
	DECLARE Var_AjustaFecAmo	CHAR(1);
	DECLARE Var_AjusFecExiVen	CHAR(1);
	DECLARE Entero_Cero			INT;
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE SalidaSI			CHAR(1);


	DECLARE Var_Control					VARCHAR(100);

	DECLARE Var_CobraSeguroCuota 		CHAR(1);
	DECLARE Var_CobraIVASeguroCuota 	CHAR(1);
	DECLARE Var_MontoSeguroCuota 		DECIMAL(12,2);


	SET Entero_Cero			:= 0 ;
	SET Decimal_Cero		:= 0.00;
	SET Cadena_Vacia		:= '';
	SET Var_FinAni			:='F';
	SET Var_DiaHabilSig		:='S';
	SET Var_AjustaFecAmo	:='S';
	SET Var_AjusFecExiVen	:='N';
	SET SalidaSI			:= 'S';
    ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr    := 999;
            SET Par_ErrMen    := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
            'Disculpe las molestias que esto le ocasiona. Ref: SP-BANCREPAGCRECAMORPRO');
            SET Var_Control := 'SQLEXCEPTION';
        END;
        SELECT CobraSeguroCuota, CobraIVASeguroCuota INTO Var_CobraSeguroCuota, Var_CobraIVASeguroCuota
            FROM PRODUCTOSCREDITO
                WHERE ProducCreditoID = Par_ProdCredID;


        SET Var_MontoSeguroCuota := (SELECT Monto
										FROM ESQUEMASEGUROCUOTA AS Esq INNER JOIN
											CATFRECUENCIAS AS Cat ON Esq.Frecuencia=Cat.FrecuenciaID
											WHERE ProducCreditoID = Par_ProdCredID
											AND Frecuencia = Par_PagoCuota ORDER BY Dias ASC LIMIT 1);

		SET Var_CobraSeguroCuota 	:= IFNULL(Var_CobraSeguroCuota, 'N');
		SET Var_CobraIVASeguroCuota := IFNULL(Var_CobraIVASeguroCuota, 'N');
		SET Var_MontoSeguroCuota 	:= IFNULL(Var_MontoSeguroCuota, Entero_Cero);

		CALL CREPAGCRECAMORPRO(	Entero_Cero,
                                Par_Monto,				Par_Tasa,		  			Par_Frecu, 	    		Par_PagoCuota,		Var_FinAni,
								Entero_Cero,			Par_FechaInicio,  			Par_NumeroCuotas,		Par_ProdCredID,		Par_ClienteID,
								Var_DiaHabilSig, 		Var_AjustaFecAmo, 			Var_AjusFecExiVen, 		Par_ComAper,		Decimal_Cero,
								Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota, 	Var_MontoSeguroCuota,	Entero_Cero,       Par_Salida,
								Par_NumErr,             Par_ErrMen,            		Par_NumTran,	   		Par_Cuotas,	   		Par_Cat,
								Par_MontoCuo,           Par_FechaVen,        		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
								Aud_DireccionIP,  		Aud_ProgramaID,			    Aud_Sucursal,	   		Aud_NumTransaccion);

		IF(Par_NumErr != 0) THEN
			LEAVE ManejoErrores;
        END IF;

	END ManejoErrores;

	 IF(Par_Salida = SalidaSI) THEN

		IF (Par_NumErr != Entero_Cero) THEN
			SELECT
                Entero_Cero 	AS Tmp_Consecutivo, 	Cadena_Vacia 	AS Tmp_FecIni,			Cadena_Vacia 			AS Tmp_FecFin,
                Cadena_Vacia 	AS Tmp_FecVig,			Entero_Cero 	AS Tmp_Capital,			Entero_Cero 			AS Tmp_Interes,
                Entero_Cero 	AS Tmp_Iva,				Entero_Cero 	AS Tmp_SubTotal,		Entero_Cero 			AS Tmp_Insoluto,
                Entero_Cero 	AS Tmp_Dias,			Entero_Cero 	AS Var_Cuotas,			Aud_NumTransaccion 		AS NumTransaccion,
                Entero_Cero 	AS Var_CAT,				Cadena_Vacia 	AS Par_FechaVenc,		Cadena_Vacia 			AS Par_FechaInicio,
                Entero_Cero 	AS MontoCuota,          Entero_Cero 	AS TotalCap,			Entero_Cero 			AS TotalInt,
                Entero_Cero 	AS TotalIva,
                Cadena_Vacia 	AS CobraSeguroCuota,
                Entero_Cero 	AS MontoSeguroCuota,
                Entero_Cero 	AS IVASeguroCuota,
                Entero_Cero 	AS TotalSeguroCuota,
                Entero_Cero 	AS TotalIVASeguroCuota,
                Entero_Cero 	AS TotalOtrasComisiones,
                Entero_Cero 	AS TotalIVAOtrasComisiones,
                Par_NumErr 		AS NumErr,
                Par_ErrMen 		AS ErrMen;
		END IF;
	END IF;
END TerminaStore$$
