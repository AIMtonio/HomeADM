package credito.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import credito.bean.TotalAplicadosWSBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class TotalAplicadosWSDAO extends BaseDAO{
	
	public TotalAplicadosWSDAO(){
		super();
	}
	
	public List<TotalAplicadosWSBean> totalAplicadoRep(
			TotalAplicadosWSBean totalAplicadosWSBean, int tipoLista) {
		// TODO Auto-generated method stub
		List listaResultado = null;
		
		try{
		String query = "call TOTALAPLICADOSWSREP(?,?,?,?,?  ,?,?,?,?,?   ,?,?)";
		
		Object[] parametros ={
				Utileria.convierteFecha(totalAplicadosWSBean.getFechaInicial()),
				Utileria.convierteFecha(totalAplicadosWSBean.getFechaFin()),
				Utileria.convierteEntero(totalAplicadosWSBean.getInstitNominaID()),
				Utileria.convierteEntero(totalAplicadosWSBean.getConvenioNominaID()),
				tipoLista,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"TotalAplicadosWSDAO.totalAplicadoRep",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TOTALAPLICADOSWSREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TotalAplicadosWSBean totalAplicadosWSBean= new TotalAplicadosWSBean();
				totalAplicadosWSBean.setFechaPago(resultSet.getString("FechaPago"));
				totalAplicadosWSBean.setDescProducto(resultSet.getString("DescProducto"));
				totalAplicadosWSBean.setMovimientoID(resultSet.getString("MovimientoID"));
				totalAplicadosWSBean.setCreditoID(resultSet.getString("CreditoID"));
				totalAplicadosWSBean.setDescInstNomina(resultSet.getString("DescInstNomina"));
				
				totalAplicadosWSBean.setConvNominaDesc(resultSet.getString("ConvNominaDesc"));
				totalAplicadosWSBean.setClienteID(resultSet.getString("ClienteID"));
				totalAplicadosWSBean.setNombreCliente(resultSet.getString("NombreCliente"));
				totalAplicadosWSBean.setRFC(resultSet.getString("RFC"));
				totalAplicadosWSBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				
				totalAplicadosWSBean.setSaldoDisp(Utileria.convierteDoble(resultSet.getString("SaldoDispon")));
				totalAplicadosWSBean.setSaldoBloq(Utileria.convierteDoble(resultSet.getString("SaldoBloq")));
				totalAplicadosWSBean.setSaldoTotal(Utileria.convierteDoble(resultSet.getString("SaldoTotal")));
				totalAplicadosWSBean.setNombreInst(resultSet.getString("NombreInst"));
				totalAplicadosWSBean.setCuentaCLABE(resultSet.getString("CuentaCLABE"));
				
				totalAplicadosWSBean.setFechaAplicacion(resultSet.getString("FechaAplicacion"));
				totalAplicadosWSBean.setCapital(Utileria.convierteDoble(resultSet.getString("Capital")));
				totalAplicadosWSBean.setInteres(Utileria.convierteDoble(resultSet.getString("Interes")));
				totalAplicadosWSBean.setIvaInteres(Utileria.convierteDoble(resultSet.getString("IvaInteres")));
				totalAplicadosWSBean.setAccesorios(Utileria.convierteDoble(resultSet.getString("Accesorios")));
				
				totalAplicadosWSBean.setiVAAccesorios(Utileria.convierteDoble(resultSet.getString("IVAAccesorios")));
				totalAplicadosWSBean.setNotasCargo(Utileria.convierteDoble(resultSet.getString("NotasCargo")));
				totalAplicadosWSBean.setiVANotaCargo(Utileria.convierteDoble(resultSet.getString("IVANotaCargo")));
				totalAplicadosWSBean.setTotalPagado(Utileria.convierteDoble(resultSet.getString("TotalPagado")));
				totalAplicadosWSBean.setImportePenApli(Utileria.convierteDoble(resultSet.getString("ImportePenApli")));
				
				totalAplicadosWSBean.setTotalOperacion(Utileria.convierteDoble(resultSet.getString("TotalOperacion")));
				totalAplicadosWSBean.setNombreInstPago(resultSet.getString("NombreInstPago"));
				totalAplicadosWSBean.setCuentaPago(resultSet.getString("CuentaPago"));
				totalAplicadosWSBean.setOrigenPago(resultSet.getString("OrigenPago"));
				totalAplicadosWSBean.setConceptoPago(resultSet.getString("ConceptoPago"));
				
			
				return totalAplicadosWSBean;
			}
		});
		listaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reporte de Total Aplicados por WS", e);
		}
		return listaResultado;
	}
	
	
}
