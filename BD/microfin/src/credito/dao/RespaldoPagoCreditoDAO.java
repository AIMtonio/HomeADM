package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import credito.bean.RespaldoPagoCreditoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
			 
public class RespaldoPagoCreditoDAO extends BaseDAO{
	
	public RespaldoPagoCreditoDAO (){
		super();
	}
	
	public RespaldoPagoCreditoBean consultaPrincipal( int tipoConsulta, RespaldoPagoCreditoBean respaldoPagoCredito) {
		// Query con el Store Procedure
		
		String query = "call RESPAGCREDITOCON(?,?,?,?,?,  ?,?,?,?);";

		Object[] parametros = { 
				//respaldoPagoCredito.getTranRespaldo(),
				respaldoPagoCredito.getCreditoID(),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA, 
				Constantes.STRING_VACIO,
				"ReversaPagoCredioDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call RESPAGCREDITOCON(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				RespaldoPagoCreditoBean resPagoCredito = new RespaldoPagoCreditoBean();
				
				resPagoCredito.setTranRespaldo(String.valueOf(resultSet.getInt("TranRespaldo")));
				resPagoCredito.setCuentaAhoID(String.valueOf(resultSet.getString("CuentaAhoID")));
				resPagoCredito.setCreditoID(String.valueOf(resultSet.getString("CreditoID")));
				resPagoCredito.setFechaPago(String.valueOf(resultSet.getDate("FechaPago")));
				resPagoCredito.setMontoPagado(resultSet.getString("MontoPagado"));
				

				return resPagoCredito;

			}
		});

		return matches.size() > 0 ? (RespaldoPagoCreditoBean) matches.get(0) : null;
	}

	public MensajeTransaccionBean altaRespaldoPagoCredito(RespaldoPagoCreditoBean respaldoPagoCreditoBean) {
		// TODO Auto-generated method stub
		return null;
	}
	
	

/* Lista todos los creditos pagados durante el Día */	
public List listaCreditoPagadosDia(RespaldoPagoCreditoBean respaldoPagoCreditoBean, int tipoLista) {
	List listaCredPagados = null ;
	try{
		// Query con el Store Procedure
		String query = "call RESCREDITOSLIS(?,?,?,?,?,  ?,?,?,?,?);";
		Object[] parametros = { 
								respaldoPagoCreditoBean.getNombreCliente(),
								Utileria.convierteLong(respaldoPagoCreditoBean.getCreditoID()),
								tipoLista,
								
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"RespaldoPagoCreditoDAO.listaCreditoPagadosDia",
								parametrosAuditoriaBean.getSucursal(), 
								Constantes.ENTERO_CERO };
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call RESCREDITOSLIST(  " + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				RespaldoPagoCreditoBean respaldoPagoCredito = new RespaldoPagoCreditoBean();
				respaldoPagoCredito.setCreditoID(String.valueOf(resultSet.getString(1)));
				respaldoPagoCredito.setNombreCliente(resultSet.getString(2));
				respaldoPagoCredito.setEstatus(resultSet.getString(3));
				respaldoPagoCredito.setNombreProducto(resultSet.getString(6));
				return respaldoPagoCredito;
			}
		});
//return matches;
		listaCredPagados= matches;
	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de creditos pagados", e);
	}
	return listaCredPagados;
}
	
	
	
}
