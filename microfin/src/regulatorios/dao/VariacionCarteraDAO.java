package regulatorios.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import regulatorios.bean.VariacionCarteraBean;

import general.dao.BaseDAO;
import herramientas.Utileria;

public class VariacionCarteraDAO  extends BaseDAO{
	
	public VariacionCarteraDAO() {
		super();
	}

	// Consulta para Reporte de  Variacion de Cartera en Excel
	public List <VariacionCarteraBean> reporteCarteraVariacion(final VariacionCarteraBean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "CALL VARIACIONCARTERAREP(?,?,	?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call VARIACIONCARTERAREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				VariacionCarteraBean variacionCartera= new VariacionCarteraBean();
				
				variacionCartera.setSaldoInicialCarVig(resultSet.getString("Var_AntTotVigente"));
				variacionCartera.setNumCredSalCarVig(resultSet.getString("Var_AntNumCreVig"));
				variacionCartera.setIncremCarVig(resultSet.getString("Var_TotIncremCarVig")); 						
				variacionCartera.setNumCredIncremCarVig(resultSet.getString("Var_CredIncremCarVig")); 				
				variacionCartera.setCredOtorCarVig(resultSet.getString("Var_CreOtorga"));
				variacionCartera.setNumCredOtorCarVig(resultSet.getString("Var_CreNumOtorga"));
				variacionCartera.setInterDevCarVig(resultSet.getString("Var_IntDevMes"));
				variacionCartera.setNumCredInterDevCarVig(resultSet.getString("Var_CredIntDev")); 				
				variacionCartera.setTraspasoCarVig(resultSet.getString("Var_MtoRegula"));
				variacionCartera.setNumCredTraspasoCarVig(resultSet.getString("Var_NumCreRegula"));
				variacionCartera.setDecremCarVig(resultSet.getString("Var_TotDecremCarVig")); 						
				variacionCartera.setNumCredDecremCarVig(resultSet.getString("Var_CredDecremCarVig")); 				
				variacionCartera.setAmorCarVig(resultSet.getString("Var_MonVigPag"));
				variacionCartera.setNumCredAmorCarVig(resultSet.getString("Var_NumVigPag"));
				variacionCartera.setTrasNetCarVig(resultSet.getString("Var_TotPasVenc"));
				variacionCartera.setNumCredTrasNetCarVig(resultSet.getString("Var_NumCrePasVen"));
				variacionCartera.setSaldoFinCarVig(resultSet.getString("Var_TotVigente"));
				variacionCartera.setNumCredSaldoFinCarVig(resultSet.getString("Var_NumCreVig"));
				variacionCartera.setSaldoInicialCarVen(resultSet.getString("Var_AntTotVencido"));
				variacionCartera.setNumCredSaldoCarVen(resultSet.getString("Var_AntNumCreVen"));
				variacionCartera.setIncremCarVen(resultSet.getString("Var_TotPasVenc")); 							
				variacionCartera.setNumCredIncremCarVen(resultSet.getString("Var_NumCrePasVen")); 					
				variacionCartera.setTraspasoCarVen(resultSet.getString("Var_TotPasVenc")); 						
				variacionCartera.setNumCredTraspasoCarVen(resultSet.getString("Var_NumCrePasVen")); 				
				variacionCartera.setDecremCarVen(resultSet.getString("Var_TotDecremCarVen")); 						
				variacionCartera.setNumCredDecremCarVen(resultSet.getString("Var_CredDecremCarVen")); 			
				variacionCartera.setCredCastCarVen(resultSet.getString("Var_TotCastigo")); 									
				variacionCartera.setNumCredCastCarVen(resultSet.getString("Var_NumCreCas")); 								
				variacionCartera.setTrasNetCarVen(resultSet.getString("Var_MtoRegula")); 							
				variacionCartera.setNumCredTrasNetCarVen(resultSet.getString("Var_NumCreRegula"));
				variacionCartera.setAmorCarVen(resultSet.getString("Var_MonVenPag"));
				variacionCartera.setNumCredAmorCarVen(resultSet.getString("Var_NumVenPag"));
				variacionCartera.setSaldoFinCarVen(resultSet.getString("Var_TotVencido"));
				variacionCartera.setNumCredSaldoFinCarVen(resultSet.getString("Var_NumCreVen"));

				return variacionCartera ;
			}
		});
		return matches;
	}
}
