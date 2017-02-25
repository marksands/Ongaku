# Ongaku

A demonstration of eventing patterns, landing at RxSwift + RxSugar.

<table>
   <th></th><th>Singular</th><th>Plural</th>
   <tr>
      <td>Spatial/Synchronous</td>
      <td>T</td>
      <td>Iterator&lt;T&gt;</td>
   </tr>
   <tr>
      <td>Temporal/Asynchronous</td>
      <td>Future&lt;T&gt;</td>
      <td>Observable&lt;T&gt;</td>
   </tr>
</table>

### Spatial

The [Spatial](https://github.com/marksands/Ongaku/tree/Spatial) branch demonstrates the most basic and essential programming paradim.

### Future

The [Futures](https://github.com/marksands/Ongaku/tree/Futures) branch demonstrates the _singular temporal_ effect using [BrightFutures](https://github.com/Thomvis/BrightFutures).

### Bitter

The [Bitter](https://github.com/marksands/Ongaku/tree/bitter) branch demonstrates the _plural temporal_ effect using vanilla [RxSwift](https://github.com/ReactiveX/RxSwift).

### Master

The default [master](https://github.com/marksands/Ongaku/) branch imporves the "bitter" _plural temporal_ solution by adding [RxSugar](https://github.com/RxSugar/RxSugar) for convenience, clarity, and better reasoning of Reactive Programming.
