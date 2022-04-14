package operacionesPDM.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import operacionesPDM.bean.ConsultaEstatusSepiBean;
import operacionesPDM.beanWS.request.SP_PDM_Ahorros_ConsultaEstatusSpeiRequest;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import general.dao.BaseDAO;
import herramientas.Constantes;

public class SP_PDM_Ahorros_ConsultaEstatusSpeiDAO extends BaseDAO {
	
	public SP_PDM_Ahorros_ConsultaEstatusSpeiDAO(){
		super();
	}
	
	public List listaSpeiEnvios(SP_PDM_Ahorros_ConsultaEstatusSpeiRequest request, int tipoLista) {
		String query = "call SPEIENVIOSLIS(?,?,?,?,?,?, ?,?,?,?,?,?,?,?);";	
		
		List listaResultado=null;
		try{
			
			Object[] parametros = {	Constantes.ENTERO_CERO,
									request.getClienteID(),
									request.getFechaInicial(),
									request.getFechaFinal(),
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									tipoLista,
									
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"SP_PDM_Ahorros_ConsultaEstatusSpeiDAO.listaCtaSpei",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SPEIENVIOSLIS(" + Arrays.toString(parametros) + ")");		
			
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConsultaEstatusSepiBean consultaEstatusSepiBean = new ConsultaEstatusSepiBean();
									
					consultaEstatusSepiBean.setCuentaOrdenante(resultSet.getString("CuentaOrd"));
					consultaEstatusSepiBean.setClaveRastreo(resultSet.getString("ClaveRastreo"));
					consultaEstatusSepiBean.setFechaEnvio(resultSet.getString("FechaEnvio"));
					consultaEstatusSepiBean.setMonto(resultSet.getString("Monto"));
					consultaEstatusSepiBean.setNombreBeneficiario(resultSet.getString("NombreBeneficiario"));
					consultaEstatusSepiBean.setBancoDestino(resultSet.getString("Nombre"));
					consultaEstatusSepiBean.setEstatus(resultSet.getString("EstatusOpe"));
					
					return consultaEstatusSepiBean;			
				}
			});
					
			listaResultado = matches;
		}catch (Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de cuentas destino", e);
		}
		return listaResultado;
	
	}

}
