package operacionesPDM.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import operacionesPDM.beanWS.request.SP_PDM_Ahorros_ConsultaSaldoRequest;
import operacionesPDM.beanWS.response.SP_PDM_Ahorros_ConsultaSaldoResponse;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class SP_PDM_Ahorros_ConsultaSaldoDAO extends BaseDAO {
	
	public SP_PDM_Ahorros_ConsultaSaldoDAO(){
		super();
	}
	
	public  SP_PDM_Ahorros_ConsultaSaldoResponse consultaSaldoWS(final SP_PDM_Ahorros_ConsultaSaldoRequest requestBean, final int tipoConsulta) {
		//Query con el Store Procedure
		SP_PDM_Ahorros_ConsultaSaldoResponse consultaSaldoResponseCon = null;			
		String query = "call CUENTASAHOCON(?,?,?,?,?, ?,?,?,?,?, ?,?,?);";
		Object[] parametros = {	Utileria.convierteLong(requestBean.getCuentaID()),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								tipoConsulta,									
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,								
								"operacionesPDM.WS.ConSaldo",								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");		
		
		try{
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SP_PDM_Ahorros_ConsultaSaldoResponse consultaSaldoResponseBean = new SP_PDM_Ahorros_ConsultaSaldoResponse();	
					
					consultaSaldoResponseBean.setCelular(resultSet.getString("TelefonoCelular"));
					consultaSaldoResponseBean.setDescripTipoCuenta(resultSet.getString("Etiqueta"));
					consultaSaldoResponseBean.setSaldoDisp(resultSet.getString("SaldoDispon"));
					consultaSaldoResponseBean.setCodigoRespuesta(resultSet.getString("NumErr"));
					consultaSaldoResponseBean.setMensajeRespuesta(resultSet.getString("ErrMen"));
										
					return consultaSaldoResponseBean;
				}
			});
					
			consultaSaldoResponseCon = matches.size() > 0 ? (SP_PDM_Ahorros_ConsultaSaldoResponse) matches.get(0) : null; 
			
			
		}catch (Exception e) {
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Consultar Saldos WS", e);
		}
		
			
		return consultaSaldoResponseCon;
				
	}
}
